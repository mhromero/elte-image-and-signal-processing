fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
sigma = 0.25; % noise intensity
s1 = sin(2*pi * 440 * t); % musical tone A
n = sigma * randn(size(s1)); % white noise
s2 = s1 + n; % noisy signal
sound([s1, s2, n], fs)
N = 5; % window size
s3 = zeros(size(s2)); % filtered signal
for i = 1:length(s2)-N+1
s3(i) = mean(s2(i:i+N-1)); % average of the window
end
sound([s1, s2, s3], fs)

%3.7
[y, fs]= audioread('audio/cmajor.wav');
% [y, fs]= wavread('audio/cmajor.wav'); % old command
y = mean(y, 2); % stereo -> mono
f = fft(y);
f1 = f(1:end/2); % lower half of FFT
[p,l] = findpeaks(abs(f1),'NPeaks', 3,'SortStr'
,
'descend');
[l, i] = sort(l); p = p(i); % sorted frequency peaks
figure, hold on, plot(abs(f1)), plot(l, p,'ro')
d = floor(min(diff(l))/2); % filter width
y1 = []; % output signal
for i = 1:3
    yi = 0;
    n = floor((length(f1)-d)/l(i))-1;
for k = 1:n % fundamental + overtones
    % the 4 is the order of the filter tinker around if its too big or too
    % small it wont be good, same for the d parameter
    [b, a] = butter(4, [k*l(i)-d, k*l(i)+d]/length(f1));
    yi = yi + filter(b, a, y);
end
y1 = [y1; yi];
end
y1 = [y1; zeros(fs/2, 1); y];
sound(y1, fs);
audiowrite('audio/cmajor_part.wav', y1, fs);
% wavwrite(y1, fs,
'audio/cmajor_part.wav'); % old command

% 3.8
N = 12; % filter order
[b,a] = butter(N/2, [40 60] / (fs / 2),'stop');
s8 = filter(b, a, s);
figure, plot(abs(fft(s8)))
% if the plot is a mistake like this then the filter is too high lower the
% N (n = 4) so that you dont get a bad plot bc of a numerical error divided
% by 0
d = designfilt('bandstopiir'
,'FilterOrder', N, ...
'HalfPowerFrequency1', 40,'HalfPowerFrequency2', 60, ...
'SampleRate', fs);
filter(d, s);
% the matlab filter is better bc it has a more precise numerical
% implementation
