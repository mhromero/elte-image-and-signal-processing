L = im2double(imread('image_pyramids_and_enhancement/images/lena_dist.png'));
L1 = medfilt2(L, [3 3]); % 3x3 window median
figure, montage({L, L1},'Size', [1 2])
