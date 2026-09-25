fs = 8000; % sampling rate [Hz]
len = 1; % length [s]
t = linspace(0, len, len*fs + 1); t(end) = []; % sampling points
s1 = sin(2*pi * 440 * t); % sine wave
sound(s1, fs)

n = 10;
for i = 2:n
    s = s + sin(2*pi * 440 * i * t) / 2 ^ i * 2
end
sound(s, fs)
