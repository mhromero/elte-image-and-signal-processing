% Maria Romero Huertas (MVIRZV)

%% Input
[y, fs] = audioread('audio/audio_15.wav');
y1 = y(1:end/2);
y2 = y(end/2+1:end);

%% Volume distortion detected: higher amplitude in second half

%% White noise
% Gaussian filter
b = [1 4 6 4 1]/16;      % 5-tap Gaussian FIR coefficients
a = 1;
y2_tmp = filtfilt(b, a, y2);   % zero-phase smoothing

% Stronger low-pass 
N  = 256;                 % filter order 
fc = 5000;                % cutoff frequency in Hz

d1 = designfilt('lowpassfir', ...
    'FilterOrder', N, ...
    'CutoffFrequency', fc, ...
    'SampleRate', fs);

y2_clean = filtfilt(d1, y2_tmp);   % zero-phase filtering (no phase shift)

%% Normalization (volume alignment)
y2 = y2_clean / max(abs(y2_clean)) * max(abs(y1));


%% Output
y = [y1; y2];
sound(y, fs);

