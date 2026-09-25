% HAAR WAVELET DECOMPOSITION 2D
%
% Parameters:
%   X       input image (assuming the dimensions are the power of 2)
%   level   level of decomposition
% Returns:
%   Y       Haar wavelet coefficients (pyramid)
%
function Y = haar2(X, level)
    [M, N] = size(X);
    Y = double(X);
    for i = 1:level
        % vertical
        A = (Y(1:2:M, 1:N) + Y(2:2:M, 1:N)) / sqrt(2);
        D = (Y(1:2:M, 1:N) - Y(2:2:M, 1:N)) / sqrt(2);
        Y(1:M, 1:N) = [A; D];
        % horizontal
        A = (Y(1:M, 1:2:N) + Y(1:M, 2:2:N)) / sqrt(2);
        D = (Y(1:M, 1:2:N) - Y(1:M, 2:2:N)) / sqrt(2);
        Y(1:M, 1:N) = [A, D];
        % step
        M = M / 2;
        N = N / 2;
    end
end
