L = rgb2gray(imread('images/lena.png'));
Q = dlmread('jpeg_q.txt');              % quantization matrix
C = zeros(size(L), 'int8');             % compressed representation
L1 = zeros(size(L));                    % compressed image
for i = 1:64
    for j = 1:64
        ii = (i-1)*8+1:i*8;             % tile indices
        jj = (j-1)*8+1:j*8;
        Di = dct2(L(ii, jj));           % tile DCT
        Ci = round(Di ./ Q);            % quantization
        C(ii, jj) = Ci;
        L1(ii, jj) = idct2(Q .* Ci);    % decompress
    end
end
L1 = uint8(L1);
figure, montage({L, L1})
