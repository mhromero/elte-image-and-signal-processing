L = im2double(imread('images/image_15.png'));

% Remove salt and pepper noise
% Median filter only works on 2D so we apply it channel by channel
L1 = L;
for i = 1:3
    L1(:,:,i) = medfilt2(L1(:,:,i), [3 3]);
end

% Rotate image to keep the horizon straight
L2 = imrotate(L1, 2, 'bicubic');

% Crop it to remove black edges
EDGE = 30
L3 = L2(EDGE:end-EDGE, EDGE:end-EDGE, :); 

figure, imshow([L3]);
