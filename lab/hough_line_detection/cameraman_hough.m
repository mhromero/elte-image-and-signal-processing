B = imread('cameraman.tif');
% edge detection
E = edge(B, 'canny');
% line detection
[H, T, R] = hough(E, 'Theta', -40:0);           % limited angle
P  = houghpeaks(H, 1);                          % highest peaks
lines = houghlines(E, T, R, P, ...              % extract lines
                   'FillGap', norm(size(B)));   % fill every gap
fprintf('Tripod angle: %d degrees\n', abs(T(P(2))));
% display
figure, imshow(B), hold on
xy = [lines.point1; lines.point2];              % coordinates
plot(xy(:,1), xy(:,2), 'r', 'LineWidth', 2);    % line overlay
