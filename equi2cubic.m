function [out] = equi2cubic(im, output_size, vfov)

    % Rotation matrix - x axis
    % Angle in degrees
    function [mat] = rotx(ang)
        mat = [1 0 0; 
            0 cosd(ang) -sind(ang); 
            0 sind(ang) cosd(ang)];
    end

    % Rotation matrix - y axis
    % Angle in degrees
    function [mat] = roty(ang)
        mat = [cosd(ang) 0 sind(ang); 
            0 1 0; 
            -sind(ang) 0 cosd(ang)];
    end

    % Rotation matrix - z axis
    % Angle in degrees    
    function [mat] = rotz(ang)
        mat = [cosd(ang) -sind(ang) 0; 
            sind(ang) cosd(ang) 0; 
            0 0 1];
    end

% Set up default parameters
% Default output size
if nargin == 1
    n = size(im, 2);
    output_size = 8*(floor(n/pi/8));
end

% Default vertical FOV
if nargin <= 2, vfov = 90; end
% Error if invalid # of input arguments
if nargin == 0 || nargin > 3, error('Insufficient arguments'); end

vfov = vfov*pi/180; % Convert to radians

% Output images
out = cell(1,6);

% Define yaw, pitch and roll for viewing of each cube face
% In degrees
views = [0 0 0; % Front
         90 0 0; % Right
         180 0 0; % Back
         -90 0 0; % Left
         0 90 0; % Top
         0 -90 0]; % Bottom

% Define top left point of equirectangular in normalized co-ordinates
output_width = output_size;
output_height = output_size;
input_width = size(im,2);
input_height = size(im,1);
topLeft = [-tan(vfov/2)*(output_width/output_height), -tan(vfov/2), 1];

% Scaling factor for grabbing pixel co-ordinates
uv = [-2*topLeft(1)/output_width, -2*topLeft(2)/output_height, 0];

% Equirectangular lookups 
res_acos = 2*input_width;
res_atan = 2*input_height;
step_acos = pi / res_acos;
step_atan = pi / res_atan;
lookup_acos = [-cos((0:res_acos-1)*step_acos) 1];
lookup_atan = [tan(step_atan/2 - pi/2) tan((1:res_atan-1)*step_atan ...
   - pi/2) tan(-step_atan/2 + pi/2)];

% Output face co-ordinates
[X, Y] = meshgrid(0:output_width-1, 0:output_height-1);
X = X(:);
Y = Y(:);

% Input image co-ordinates
[XImage, YImage] = meshgrid(1:input_width, 1:input_height);

for idx = 1 : size(views,1)
    % Get yaw, pitch and roll of a particular view
    yaw = views(idx,1);
    pitch = views(idx,2);
    roll = views(idx,3);
    
    % Get transformation matrix
    transform = roty(yaw)*rotx(pitch)*rotz(roll);
    
    % Rotate grid co-ordinates for cube face so that we are
    % writing to the right face
    points = [topLeft(1) + uv(1)*X.'; topLeft(2) + uv(2)*Y.'; ...
        topLeft(3) + uv(3)*ones(1, numel(X))];
    moved_points = transform * points;
    x_points = moved_points(1,:);
    y_points = moved_points(2,:);
    z_points = moved_points(3,:);
    
    % Determine correct equirectangular co-ordinates
    % for each pixel within the cube face to sample from
    nxz = sqrt(x_points.^2 + z_points.^2);
    phi = zeros(1, numel(X));
    theta = zeros(1, numel(X));
    
    ind = nxz < realmin;
    phi(ind & y_points > 0) = pi/2;
    phi(ind & y_points <= 0) = -pi/2;
    
    ind = ~ind;
    phi(ind) = interp1(lookup_atan, 0:res_atan, ...
        y_points(ind)./nxz(ind), 'linear')*step_atan - (pi/2);
    theta(ind) = interp1(lookup_acos, 0:res_acos, ...
        -z_points(ind)./nxz(ind), 'linear')*step_acos;
    theta(ind & x_points < 0) = -theta(ind & x_points < 0);
    
    % Find equivalent pixel co-ordinates
    inX = (theta / pi) * (input_width/2) + (input_width/2) + 1;
    inY = (phi / (pi/2)) * (input_height/2) + (input_height/2) + 1;
    
    % Cap if out of bounds
    inX(inX < 1) = 1;
    inX(inX >= input_width) = input_width;
    inY(inY < 1) = 1;
    inY(inY >= input_height) = input_height;
    
    % Initialize output image
    out{idx} = zeros([output_height, output_width, size(im,3)], class(im));
    
    % Store output colours here
    out_pix = zeros(numel(X), size(im, 3));
    
    % For each pixel position calculated previously,
    % get the corresponding colour values
    for c = 1 : size(im, 3)
        chan = double(im(:,:,c));
        out_pix(:,c) = interp2(XImage, YImage, chan, inX, inY, 'linear');
    end
    
    % Each column of out_pix is the output of a single channel
    % Reshape so that it becomes a matrix instead and place into output
    for c = 1 : size(im, 3)
        out{idx}(:,:,c) = cast(reshape(out_pix(:,c), output_height, ...
            output_width), class(im));
    end              
end

end