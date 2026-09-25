%% Input
[y, fs] = audioread('audio/audio_15.wav');
y1 = y(1:end/2);
y2 = y(end/2+1:end);
%sound(y, fs)
pause(ceil(length(y) / fs))

%% Time domain analysis
t = (0:length(y)-1) / fs;
t1 = t(1:end/2);
t2 = t(end/2+1:end);
figure, plot(t1, y1, 'b', t2, y2, 'r')
% Conclusions:
%   no extremal values => not salt-pepper noise
%   different amplitudes => volume distortion (higher in second half)

%% Frequency domain analysis
f1 = fft(y1);
f2 = fft(y2);
f1 = f1(1:end/2);
f2 = f2(1:end/2);
ft = linspace(0, fs/2, length(f1)+1); ft(end) = [];
figure
subplot(2, 1, 1), plot(ft, abs(f1))
subplot(2, 1, 2), plot(ft, abs(f2))
linkaxes
% Conlusions:
%   no high frequency noise
%   possible low frequency noise -> zoom in to low frequencies

%% Frequency domain analysis (contd.)
ft_mask = ft < 1500;
figure
subplot(2, 1, 1), plot(ft(ft_mask), abs(f1(ft_mask)))
subplot(2, 1, 2), plot(ft(ft_mask), abs(f2(ft_mask)))
linkaxes
% Conclusion:
%   power line interference at 50-60 Hz and overtones
%   possible pitch shift?



%% White noise suppression
%L = 11;
%w = gausswin(L);
%w = w / sum(w);
%y2_clean = filtfilt(w, 1, y2);

% Gaussian smoother
b = [1 4 6 4 1]/16;      % 5-tap Gaussian FIR coefficients
a = 1;
y2_tmp = filtfilt(b, a, y2);   % zero-phase smoothing

% --- Step 2: Stronger low-pass using designfilt
N  = 256;                 % filter order (controls steepness)
fc = 5000;                % cutoff frequency in Hz (4.5–6 kHz for speech)

d1 = designfilt('lowpassfir', ...
    'FilterOrder', N, ...
    'CutoffFrequency', fc, ...
    'SampleRate', fs);

y2_clean = filtfilt(d1, y2_tmp);   % zero-phase filtering (no phase shift)

%% Time domain analysis v2
figure, plot(t1, y1, 'b', t2, y2_clean, 'r')
% Conclusions:
%   possible volume distortion

%% Frequency domain analysis v2
f2 = fft(y2_clean);
f2 = f2(1:end/2);
ft_mask = ft < 1500;
figure
subplot(2, 1, 1), plot(ft(ft_mask), abs(f1(ft_mask)))
subplot(2, 1, 2), plot(ft(ft_mask), abs(f2(ft_mask)))
linkaxes
% Conlusions:
%   shifted frequencies => possible pitch shift

%% Pitch correction
% Matching peaks: 573.228->407.848, 1124.05->793.735
% Pitch shift:
%ratio = [573.228 1124.05] ./ [407.848 793.735] % ~ sqrt(2)
%nsemitones = 12 * log2(ratio) % ~ 6
%y2 = shiftPitch(y2, 6);
% Normalization
y2 = y2_clean / max(abs(y2_clean)) * max(abs(y1));

%% Output
figure, plot(t1, y1, 'b', t2, y2, 'r')
y = [y1; y2];
sound(y, fs)
pause(ceil(length(y) / fs))

f1 = fft(y1);
f2 = fft(y2);
f1 = f1(1:end/2);
f2 = f2(1:end/2);
ft = linspace(0, fs/2, length(f1)+1); ft(end) = [];
figure
subplot(2, 1, 1), plot(ft, abs(f1))
subplot(2, 1, 2), plot(ft, abs(f2))
linkaxes

outFile = fullfile(pwd,'audio','audio_15_filtered.wav');
audiowrite(outFile, y, fs);
fprintf('File saved at: %s\n', outFile);


