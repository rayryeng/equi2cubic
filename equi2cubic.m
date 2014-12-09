% Assumes input is equirectangular and is a 2:1 ratio
function [out] = equi2cubic(im, w)

if nargin == 1
    % width and height of each cubic face
    % Default pulled from Hugin
    w = 8*floor(size(im,2)/pi/8);
elseif nargin ~= 2
    error('Must provide at least 1 input parameter');
end

mappings = cell(1,6);

% Top face
[X,Y] = meshgrid(linspace(1,-1,w), linspace(1,-1,w));
X = X.';
Y = Y.';
mappings{1} = struct('X', X, 'Y', Y, 'Z', ones(size(X)));

% Bottom face
[X,Y] = meshgrid(linspace(-1,1,w), linspace(1,-1,w));
X = X.';
Y = Y.';
mappings{2} = struct('X', X, 'Y', Y, 'Z', -ones(size(X)));

% Left Face
[X,Z] = meshgrid(linspace(1,-1,w), linspace(1,-1,w));
mappings{3} = struct('X', X, 'Y', ones(size(X)), 'Z', Z);

% Right Face
[X,Z] = meshgrid(linspace(-1,1,w), linspace(1,-1,w));
mappings{4} = struct('X', X, 'Y', -ones(size(X)), 'Z', Z);

% Front Face
[Y,Z] = meshgrid(linspace(1,-1,w), linspace(1,-1,w));
mappings{5} = struct('X', -ones(size(Y)), 'Y', Y, 'Z', Z);

% Back Face
[Y,Z] = meshgrid(linspace(-1,1,w), linspace(1,-1,w));
mappings{6} = struct('X', ones(size(Y)), 'Y', Y, 'Z', Z);

% Stores the output cubic images
out = cell(1,6);

% For each cubic face...
for idx = 1 : numel(mappings)
    
    % Get cubic co-ordinates for this face
    X = mappings{idx}.X;
    Y = mappings{idx}.Y;
    Z = mappings{idx}.Z;
    
    % Get co-ordinates that map on the sphere
    x = X.*sqrt(1 - 0.5*Y.^2 - 0.5*Z.^2 + (1/3)*(Y.^2.*Z.^2));
    y = Y.*sqrt(1 - 0.5*Z.^2 - 0.5*X.^2 + (1/3)*(X.^2.*Z.^2));
    z = Z.*sqrt(1 - 0.5*X.^2 - 0.5*Y.^2 + (1/3)*(X.^2.*Y.^2));
    
    % Get equivalent spherical co-ordinates
    r = sqrt(x.^2 + y.^2 + z.^2); % Should theoretically be 1
    theta = acos(z./r); % Vertical
    phi = atan2(y, x); % Horizontal
    
    % These co-ordinates are between -pi to pi for phi and 0 to pi for 
    % theta
    % Find any values for phi < 0, then add 2*pi to it
    phi(phi < 0) = 2*pi + phi(phi < 0);
    
    % Figure out the row and column locations to sample equirectangular
    rows = floor((theta/pi)*size(im,1)) + 1;
    cols = floor((phi/(2*pi))*size(im,2)) + 1;
    ind = sub2ind([size(im,1), size(im,2)], rows, cols);
    
    % Create output cube face image
    out_im = zeros([w w], class(im));
        
    % For each channel we have in the image, copy the pixels over
    for num = 1 : size(im,3)
        chan = im(:,:,num);
        pix = chan(ind);
        out_im(:,:,num) = pix;
    end
    % Save this in the cell array
    out{idx} = out_im;    
end

end