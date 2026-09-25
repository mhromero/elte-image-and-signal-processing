K1 = fspecial('gaussian', 3, 0.5);  % Gaussian kernel
K2 = fspecial('laplacian', 0);      % Laplacian kernel
L = im2double(imread('images/lena.png'));
[M,N,~] = size(L);
P1 = zeros(2*M, 2*N);               % Gaussian pyramid
P2 = zeros(2*M, 2*N);               % Laplacian pyramid
L1 = L;
while min(M, N) >= 1
    [M,N,~] = size(L1);
    L2 = imfilter(L1, K2);          % Laplacian
    Z = zeros(M, N);
    P1(1:2*M, 1:2*N) = [Z, L1(:, :, 1); L1(:, :, 2), L1(:, :, 3)];
    P2(1:2*M, 1:2*N) = [Z, L2(:, :, 1); L2(:, :, 2), L2(:, :, 3)];
    L1 = imfilter(L1, K1);          % Gaussian
    L1 = L1(2:2:end, 2:2:end, :);   % downsample
end
figure, montage({P1, P2})
