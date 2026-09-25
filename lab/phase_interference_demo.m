% Minimal phase experiment (MATLAB)
fs = 44100; T = 1; f = 440;
t = (0:1/fs:T-1/fs)';

ph = [0, pi/2, pi];     % try different phases

% Play each tone separately (same loudness regardless of phase)
for k = 1:numel(ph)
    s = sin(2*pi*f*t + ph(k));
    sound(s, fs); pause(T + 0.2);
end

% Combine two tones and play (interference happens here)
i = 1; j = 2;            % choose which two phases to add
s_sum = sin(2*pi*f*t + ph(i)) + sin(2*pi*f*t + ph(j));
s_sum = s_sum / max(abs(s_sum));   % simple anti-clip
sound(s_sum, fs);

% Quick specials (uncomment to try):
% Constructive (0 & 0): louder (~+6 dB)
s2 = sin(2*pi*f*t) + sin(2*pi*f*t + 0);
sound(s2/max(abs(s2)), fs)
% Destructive (0 & pi): cancels (≈ silence)
s3 = sin(2*pi*f*t) + sin(2*pi*f*t + pi);
sound(s3, fs)


