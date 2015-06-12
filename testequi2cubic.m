% Read in the image
equi = imread('arch_equi.jpg');

% Close all figures and create cubic images
close all;
out = equi2cubic(equi, 500); % Set to 500 x 500

% Now show all of the cube faces as a demonstration
names = {'Front Face', 'Right Face', 'Back Face', 'Left Face', ...
    'Top Face', 'Bottom Face'};
names_to_save = {'cube_front.jpg', 'cube_right.jpg', 'cube_back.jpg', ...
    'cube_left.jpg', 'cube_top.jpg', 'cube_bottom.jpg'};

% Show original equirectangular image
figure;
imshow(equi);
title('Equirectangular Image');

% Show the cube faces and also write them to disk
figure;
for idx = 1 : numel(names)
    % Show image in figure and name the face
    subplot(2,3,idx);
    imshow(out{idx});
    title(names{idx});
    % Write the image to disk
    imwrite(out{idx}, names_to_save{idx});
end

% Show a montage
mont_image = horzcat(out{:});
figure;
imshow(mont_image);
title('Montage - Front, Right, Back, Left, Top, Bottom');