B = im2double(imread('gantrycrane.png'));
% edge detection
E = edge(rgb2gray(B), 'canny');
% line detection
[H, T, R] = hough(E);                       % Hough transform
P  = houghpeaks(H, 10);                     % 10 highest peaks
lines = houghlines(E, T, R, P);             % line segments
% display
figure, imshow(B), hold on
for k = 1:length(lines)
    xy = [lines(k).point1; lines(k).point2];        % coordinates
    plot(xy(:,1), xy(:,2), 'r', 'LineWidth', 2);    % line overlay
    plot(xy(:,1), xy(:,2), 'y.', 'MarkerSize', 20); % line endpoints
end
