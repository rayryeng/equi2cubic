% Read in the image
equi = imread('arch_equi.jpg');

% Close all figures and create cubic images
close all;
out = equi2cubic(equi);

% Now show all of the cube faces as a demonstration
names = {'Top Face', 'Bottom Face', 'Left Face', 'Right Face', ...
    'Front Face', 'Back Face'};

% Show original equirectangular image
figure;
imshow(equi);
title('Equirectangular Image');

% Show the cube faces
figure;
for idx = 1 : numel(names)
    % Show image in figure and name the face
    subplot(2,3,idx);
    imshow(out{idx});
    title(names{idx});
end