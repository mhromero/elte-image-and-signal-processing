A = im2double(imread('images/A4.png'));
B = adapthisteq(A);
figure, montage({A, B})
% inspect the first lines (background gradient)
a = A(1, :); b = B(1, :);
N = length(a); x = 1:N;
figure, plot(x, a, x, b)
% remove linear trend
p = robustfit(x, b);
b = b - polyval(flip(p), x);
figure, plot(x, b)
% estimate periodicity
[p, f] = periodogram(b, [], [], N);
[m, k] = findpeaks(p, f, 'NPeaks', 1, 'SortStr', 'descend');
figure, plot(f, p, k, m, 'o')
fprintf('Estimated number of tiles: %d\n', round(k))
