fs = 8000;
len = 1;
t = linspace(0, len, len*fs+1);
t(end) = [];
s1 = sin(2*pi* 440 * t);
%sound(s1, fs)

s2 = s1 + sin(2*pi* 550 * t) + sin((2*pi* 660 * t));
%sound(s2, fs)

n = 8;
s3 = 0;
for k = 1:n
    s3 = s3 + sin(2 * pi * 440 * k * t) / 2^k*2;
end

%sound(s3, fs)

%sound(s1, fs)
len5 = floor(0.2 * fs);
w = ones(size(t));
w(1:len5) = linspace(0,1,len5);
w(end-len5+1:end) = linspace(1, 0, len5);
figure, plot(w);
s5 = w .* s1;
%plot(t(1:100), s1(1:100))
%plot(t(1:100), s5(1:100))
%sound(s5, fs)

f3 = fft(s3);
%figure, plot(abs(f3));
%figure, plot(angle(f3));
%figure, plot(abs(fftshift(f3)));

%2.7. Detect peaks on the Fourier spectra.
% 3 most prominent peaks only
[pks,locs] = findpeaks(abs(f3),'NPeaks', 3,'SortStr','descend');
%figure, hold on, plot(abs(f3)), plot(locs, pks,'ro')

ft = linspace(0, fs, length(t)+1);
ft(end) = []
cut = find(ft >= 430 & ft <=450);
f8 = f3;
f8(cut) = 0;
f8(end - cut + 2) = 0;
s8 = real(ifft(f8));

%sound(s8, fs);

[y, fs]= audioread('audio/cmajor.wav');
y = mean(y, 2);
f = fft(y);
f1 = f(1:end/2);
[p,l] = findpeaks(abs(f1),'NPeaks', 3,'SortStr','descend');
[l, i] = sort(l);
p = p(i);
figure, hold on, plot(abs(f1)), plot(l, p,'ro');

d = floor(min(diff(l))/4);
y1 = [];

for i = 1:3
    fi = zeros(size(f1));       % empty (positive-freq) spectrum for this note
    n  = floor((length(f1)-d)/l(i));  % how many harmonics fit before Nyquist

    for k = 1:n                 % fundamental + overtones
        % copy a small band around k*l(i) into fi
        fi(k*l(i)-d : k*l(i)+d) = f1(k*l(i)-d : k*l(i)+d);
    end

    % Recreate full (Hermitian) spectrum so ifft returns a real signal:
    % [positive freqs] ; [Nyquist bin] ; [negative freqs = conj(reverse(1…end-1))]
    fi = [fi; 0; conj(fi(end:-1:2))];

    yi = real(ifft(fi));        % time signal for this note only
    y1 = [y1; yi];              % append it (one after the other)
end
y1 = [y1; zeros(fs/2, 1); y];
%sound(y1, fs);
%audiowrite('audio/cmajor_part.wav', y1, fs);

n = 5;
figure
for i = 1:n
t = linspace(0, i, 30*i+1); t(end) = [];
z1 = sin(2*pi * 2 * t); z2 = sin(2*pi * 2.5 * t);
f1 = fft(z1); f2 = fft(z2); f12 = fft(z1 + z2);
%subplot(n, 1, i), hold on
%plot(abs(f1)), plot(abs(f2)), plot(10 + abs(f12))
end

t = linspace(0, 1, 30+1);
t(end) = [];
z2 = sin(2*pi * 2.5 * t);
w = flattopwin(30)';
figure, hold on
%plot(abs(fft(z2)))
%plot(abs(fft(w .* z2)))

t = linspace(0, 1, 30+1); t(end) = [];
z3 = sin(2*pi * 2.8 * t); z4 = sin(2*pi * 3.9 * t);
f3 = fft(z3); f4 = fft(z4);
figure
%subplot(311), hold on, plot(abs(f3)), plot(abs(f4))
%subplot(312), plot(abs(fft(z3 + z4)))
w = gausswin(30)';
%subplot(313), plot(abs(fft(w .* (z3 + z4))))

fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
sigma = 0.25; % noise intensity
s1 = sin(2*pi * 440 * t); % musical tone A
n = sigma * randn(size(s1)); % white noise
s2 = s1 + n; % noisy signal
%sound([s1, s2, n], fs)

N = 5; % window size
s3 = zeros(size(s2)); % filtered signal
for i = 1:length(s2)-N+1
s3(i) = mean(s2(i:i+N-1)); % average of the window
end
%sound([s1, s2, s3], fs)

%w = [1, 2, 1] / 4; % integer kernel of size 3
%w = [1, 4, 6, 4, 1] / 16; % integer kernel of size 3
w = gausswin(5);
w = (w / sum(w)).'; % built-in function
N = length(w);
s3 = zeros(size(s2));
for i = 1:length(s2)-N+1
s3(i) = sum(w .* s2(i:i+N-1)); % weighted sum
end
%sound([s1, s2, s3], fs);

s4 = conv(s2, w,'same');
s5 = filter(w, 1, s2);

%figure, plot(t(1:100), s1(1:100), t(1:100), s3(1:100)) % left shift
%figure, plot(t(1:100), s1(1:100), t(1:100), s4(1:100)) % centered
%figure, plot(t(1:100), s1(1:100), t(1:100), s5(1:100)) % right

N = 5; % window size (odd)
pad = (N-1)/2; % padding size
%sp = padarray(s2, [0, pad], 0); % zero padding
%sp = padarray(s2, [0, pad],'replicate'); % replicate first/last
%sp = padarray(s2, [0, pad],'symmetric'); % symmetric extension
sp = padarray(s2, [0, pad],'circular'); % periodic extension
s6 = zeros(size(s2)); % filtered signal
for i = 1:length(s2)
s6(i) = mean(sp(i:i+N-1)); % average of the window
end
%sound([s1, s2, s6], fs)
%figure, plot(t(1:100), s1(1:100), t(1:100), s6(1:100))

fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
d = 0.05; % noise density
A = 1; % noise intensity
s1 = sin(2*pi * 440 * t); % musical tone A
idx1 = rand(size(s1)) < 0.5 * d; %'white' indices
idx2 = rand(size(s1)) < 0.5 * d; %'black' indices
s2 = s1; s2(idx1) = A; s2(idx2) = -A; % noisy signal
%sound([s1, s2], fs)

N = 5; % window size
s3 = zeros(size(s2)); % filtered signal
for i = 1:length(s2)-N+1
s3(i) = median(s2(i:i+N-1)); % median of the window
end
%sound([s1, s2, s3], fs)

s4 = medfilt1(s2, N);

%sound([s1, s2, s4], fs)

fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
s = 0;
for f = [440, 550, 660] % sinusoid frequencies
s = s + sin(2*pi * f * t);
end
%figure, plot(abs(fft(s))) % Fourier magnitude

N = 12; % filter order
d3 = designfilt('highpassiir', ...
    'FilterOrder', N, ...
    'HalfPowerFrequency', 600, ...
    'SampleRate', fs);
s3 = filter(d3, s);
%figure, plot(abs(fft(s3)))

[y, fs]= audioread('audio/cmajor.wav');
% [y, fs]= wavread('audio/cmajor.wav'); % old command
y = mean(y, 2); % stereo -> mono
f = fft(y);
f1 = f(1:end/2); % lower half of FFT
[p,l] = findpeaks(abs(f1),'NPeaks', 3,'SortStr','descend');
[l, i] = sort(l); p = p(i); % sorted frequency peaks
figure, hold on, plot(abs(f1)), plot(l, p,'ro')
d = floor(min(diff(l))/2); % filter width
y1 = []; % output signal
for i = 1:3
yi = 0;
n = floor((length(f1)-d)/l(i))-1;
for k = 1:n % fundamental + overtones
[b, a] = butter(4, [k*l(i)-d, k*l(i)+d]/length(f1));
yi = yi + filter(b, a, y);
end
y1 = [y1; yi];
end
y1 = [y1; zeros(fs/2, 1); y];
%sound(y1, fs);
%audiowrite('audio/cmajor_part.wav', y1, fs);

t0 = linspace(0, 16*pi, 10000+1);
t1 = linspace(0, 16*pi, 8+1); 
t2 = linspace(0, 16*pi, 12+1);
%figure, plot(t0, sin(t0),'b', t0, -sin(t0/2),'r', ...
%t1, sin(t1),'ko', t1, -sin(t1/2),'ks')
%figure, plot(t0, sin(t0),'b', t0, -sin(t0/2),'r', ...
%t2, sin(t2),'ko', t2, -sin(t2/2),'ks')

fs = 8000;
t = linspace(0, 1, fs+1); t(end) = [];
s = sin(2*pi * 440 * t);
%sound(s, fs)

s1 = s(1:2:end);
s2 = s(2:2:end);
%sound(s1, fs/2)
%sound(s2, fs/2)

s3 = (s(1:2:end) + s(2:2:end)) / 2;
%sound(s3, fs/2)
% equivalent lowpass filter + decimation
s4 = filter([0.5 0.5], 1, s);
s4 = s4(2:2:end);
%sound(s4, fs/2)

s5 = resample(s, 1, 2);
%sound(s5, fs/2)

s1 = s(1:10:end);
%figure, plot(abs(fft(s)))
%figure, plot(abs(fft(s1)))

t = linspace(0, 1, 44100+1); t(end) = [];
s = sin(2*pi * 10000 * t);
figure, plot(abs(fft(s)))
t1 = linspace(0, 1, 8000+1); t1(end) = [];
s1 = interp1(t, s, t1);
%figure, plot(abs(fft(s1)))

fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
sigma = 0.25; % noise intensity
s1 = sin(2*pi * 440 * t); % musical tone A
n = sigma * randn(size(s1)); % white noise
s2 = s1 + n; % noisy signal
sound([s1, s2, n], fs)

fs = 8000; % sampling rate
t = linspace(0, 1, fs + 1); t(end) = []; % sampling points
d = 0.05; % noise density
A = 1; % noise intensity
s1 = sin(2*pi * 440 * t); % musical tone A
idx1 = rand(size(s1)) < 0.5 * d; %'white' indices
idx2 = rand(size(s1)) < 0.5 * d; %'black' indices
s2 = s1; s2(idx1) = A; s2(idx2) = -A; % noisy signal
%sound([s1, s2], fs)

f = 50; % frequency
A = [0.25, 0.1, 0.01]; % fundamental and overtone amplitudes
s2 = s1;
for k = 1:length(A)
s2 = s2 + A(k) * sin(2*pi * f * k * t);
end
%sound(s2, fs)












