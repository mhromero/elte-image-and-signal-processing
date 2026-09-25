% load and normalization
A1 = im2double(imread('images/P1.jpg'));
A2 = im2double(imread('images/P2.jpg'));
A1 = imadjust(A1, stretchlim(A1));
A2 = imadjust(A2, stretchlim(A2));
figure, imshow([A1, A2])
% overlapping pieces, grayscale
[M, N, ~] = size(A1);
D = N / 2;
B1 = rgb2gray(A1(:, D+1:end, :));
B2 = rgb2gray(A2(:, 1:D, :));
% initial estimation with phase correlation
tinit = imregcorr(B2, B1, 'translation');
C = imwarp(B2, tinit, 'OutputView', imref2d(size(B1)));
figure, imshowpair(B1, C)
% registration
[optimizer, metric] = imregconfig('monomodal');
treg = imregtform(B2, B1, 'affine', optimizer, metric, ...
                  'InitialTransformation', tinit);
C = imwarp(B2, treg, 'OutputView', imref2d(size(B1)));
figure, imshowpair(B1, C)
% transformation of the whole, colored image
tform = affine2d(treg.T * [1 0 0; 0 1 0; D 0 1]);
view = imref2d([M, 1.5 * N]);
C1 = imwarp(A1, affine2d, 'OutputView', view);
C2 = imwarp(A2, tform, 'OutputView', view);
% smooth, interpolated blend
W1 = imwarp(ones(M, N), affine2d, 'OutputView', view);
W2 = imwarp(ones(M, N), tform, 'OutputView', view);
W1 = bwdist(1 - W1);
W2 = bwdist(1 - W2);
W = W1 + W2; W(W == 0) = 1;
C = (W1 .* C1 + W2 .* C2) ./ W;
figure, imshow(C)
