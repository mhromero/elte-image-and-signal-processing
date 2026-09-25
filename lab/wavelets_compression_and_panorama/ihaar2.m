% HAAR WAVELET RECONSTRUCTION 2D
%
% Parameters:
%   Y       Haar wavelet coefficients (see haar2)
%   level   level of decomposition
% Returns:
%   X       reconstructed image
%
function X = ihaar2(Y, level)
    [M, N] = size(Y);
    X = double(Y);
    M = M / 2^level;
    N = N / 2^level;
    for i = 1:level
        % vertical
        A = (X(1:M, 1:2*N) + X(M+1:2*M, 1:2*N)) / sqrt(2);
        D = (X(1:M, 1:2*N) - X(M+1:2*M, 1:2*N)) / sqrt(2);
        X(1:2:2*M, 1:2*N) = A;
        X(2:2:2*M, 1:2*N) = D;
        % horizontal
        A = (X(1:2*M, 1:N) + X(1:2*M, N+1:2*N)) / sqrt(2);
        D = (X(1:2*M, 1:N) - X(1:2*M, N+1:2*N)) / sqrt(2);
        X(1:2*M, 1:2:2*N) = A;
        X(1:2*M, 2:2:2*N) = D;
        % step
        M = M * 2;
        N = N * 2;
    end
end
