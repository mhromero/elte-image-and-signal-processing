K1 = fspecial('gaussian', 3, 0.5);  % Gaussian kernel
K2 = fspecial('laplacian', 0);      % Laplacian kernel
L = rgb2gray(im2double(imread('images/lena.png')));
[M,N] = size(L);
P1 = zeros(2*M, N);                 % Gaussian pyramid
P2 = zeros(2*M, N);                 % Laplacian pyramid
L1 = L;
while M >= 1
    [M,N] = size(L1);
    L2 = imfilter(L1, K2);          % Laplacian
    P1(M+1:2*M, 1:N) = L1;
    P2(M+1:2*M, 1:N) = L2;
    L1 = imfilter(L1, K1);          % Gaussian
    L1 = L1(2:2:end, 2:2:end);      % downsample
end
figure, montage({P1, P2})
