%% Average of images
din = fullfile('watermark', 'images');       % input dir
list = dir(fullfile(din, '*.jpg'));          % list of images
B = 0;
for i = 1:length(list)
    fprintf('Read: %s\n', list(i).name);
    A = im2double(imread(fullfile(din, list(i).name)));
    B = B + rgb2gray(A);
end
B = B / length(list);           % average (grayscale)
%% Watermark mask
th = 0.75;                      % estimated threshold
alpha = 0.5;                    % estimated alpha
W = alpha * double(B > th);     % estimated watermark mask
figure, imshow(W)
%% Watermark removal
dout = 'nomark';                % output dir
mkdir(dout)
for i = 1:length(list)
    fprintf('Write: %s\n', list(i).name);
    A = im2double(imread(fullfile(din, list(i).name)));
    A = (A - W) ./ (1 - W);     % inverse operation
    imwrite(A, fullfile(dout, list(i).name));
end


