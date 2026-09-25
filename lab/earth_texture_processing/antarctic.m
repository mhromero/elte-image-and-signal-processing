% Earth texture, southern hemisphere
A = im2double(imread('images/earth.jpg'));
A = A(end/2+1:end, :, :);
A = rot90(A, 2);
% padding
P = 2;
[M, N, K] = size(A);
A = padarray(A, [0 P], 'circular');
A = padarray(A, [P 0], 'symmetric', 'pre');
A = padarray(A, [P 0], 'replicate', 'post');
% spherical coordinates of the projection points
[X, Y] = meshgrid(-M:M);
R = sqrt(X.^2 + Y.^2) / M;
Phi = (atan2(Y, X) + pi) / (2*pi) * N;
Theta = real(asin(R)) / (pi/2) * M;
% bicubic interpolation
[AX, AY] = meshgrid(-P:N+P-1, -P:M+P-1);
B = zeros(2*M+1, 2*M+1, K);
for i = 1:K
    B(:,:,i) = interp2(AX, AY, A(:,:,i), Phi, Theta, 'cubic')';
end
% disk mask
B = B .* (R <= 1);
figure, imshow(B)
