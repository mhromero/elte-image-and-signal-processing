map = dlmread('color16.txt');
A = im2double(imread('images/yellowlily.jpg'));
% Inverse colormap in RGB
B1 = rgb2ind(A, map, 'nodither');
A1 = ind2rgb(B1, map);
% Inverse colormap in L*a*b*
[M,N,~] = size(A);
P = size(map, 1);
LA = reshape(rgb2lab(A), M*N, 1, 3);
LM = reshape(rgb2lab(map), 1, P, 3);
[~, B2] = min(vecnorm(LA - LM, 2, 3), [], 2);
B2 = uint8(reshape(B2 - 1, M, N));
A2 = ind2rgb(B2, map);
figure, montage({A, A1, A2}, 'Size', [1 3])
