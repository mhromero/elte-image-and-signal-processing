map = dlmread('color16.txt');
A = im2double(imread('images/yellowlily.jpg'));
% Inverse colormap in RGB
B1 = rgb2ind(A, map, 'nodither');
A1 = ind2rgb(B1, map);
% Inverse colormap in L*a*b*
LA = rgb2lab(A);
LM = rgb2lab(map);
[M,N,~] = size(A);
B2 = zeros(M, N, 'uint8');
for i = 1:M
    for j = 1:N
        C = reshape(LA(i, j, :), 1, 3, 1);
        [~, k] = min(vecnorm(C - LM, 2, 2));
        B2(i, j) = k - 1;
    end
end
A2 = ind2rgb(B2, map);
figure, montage({A, A1, A2}, 'Size', [1 3])
