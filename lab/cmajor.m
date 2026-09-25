[y, fs]= audioread('audio/cmajor.wav');
% [y, fs]= wavread('audio/cmajor.wav'); % old command
y = mean(y, 2);             % stereo -> mono
f = fft(y);
f1 = f(1:end/2);            % lower half of FFT

[p,l] = findpeaks(abs(f1), 'NPeaks', 3, 'SortStr', 'descend');
[l, i] = sort(l); p = p(i); % sorted frequency peaks
figure, hold on, plot(abs(f1)), plot(l, p, 'ro')

d = floor(min(diff(l))/4);  % filter width
y1 = [];                    % output signal
for i = 1:3
    fi = zeros(size(f1));
    n = floor((length(f1)-d)/l(i));
    for k = 1:n             % fundamental + overtones
        fi(k*l(i)-d:k*l(i)+d) = f1(k*l(i)-d:k*l(i)+d);
    end
    fi = [fi; 0; conj(fi(end:-1:2))];
    yi = real(ifft(fi));
    y1 = [y1; yi];
end
y1 = [y1; zeros(fs/2, 1); y];
sound(y1, fs);

audiowrite('audio/cmajor_part.wav', y1, fs);
% wavwrite(y1, fs, 'audio/cmajor_part.wav'); % old command
