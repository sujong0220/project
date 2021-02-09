[sounds, Fs] = audioread('C:\Users\moonm\OneDrive\바탕 화면\MATLAB_music\도레미파솔라시도.mp3');
sound(sounds, Fs);

sounds = sounds(:, 2); % use 1 channel of stereo channel
%sounds = sounds(sounds >= 0); % remove negative value

%%
% Chart of scale's frequency
%%

E2 = 82.4; F2 = 87.3; G2b = 92.5; G2 = 98.0; A2b = 103.8; A2 = 110.0; B2b = 116.3; B2 = 123.5;
C3 = 130.8; D3b = 138.6; D3 = 146.8; E3b = 155.4; E3 = 164.8; F3 = 174.6; G3b = 185.0; G3 = 196.0; A3b = 207.6; A3 = 220.0; B3b = 233.0; B3 = 246.9;
C4 = 261.6; D4b = 277.0; D4 = 293.6; E4b = 329.8; E4 = 329.8; F4 = 349.2; G4b = 369.9; G4 = 392.0; A4b = 415.3; A4 = 440; B4b = 466.1; B4 = 493.8;
C5 = 523.2; D5b = 554.3; D5 = 587.3; E5b = 659.3; E5 = 659.3; F5 = 698.5; G5b = 740.0; G5 = 784.0; A5b = 830.8; A5 = 880.0; B5b = 932.2; B5 = 987.7;
C6 = 1046.5; D6b = 1108.7; D6 = 1174.7;
%

%%
% about global constants & variables
%%

lengths = max(length(sounds)); % sound length
range = 3000; % about Mung-ttuk coefficient
threshold = 0.3;

%%
% codes
%%

maxSound = zeros(lengths, 1); % create array with initial value: 0, size: sound length
x = [0]; % push first value: 0 to get first peak
y = [0]; % push first value: 0 to get first peak
% x, y are array about infomations of peak points

for i = 1:range:lengths
	s = i;
	e = s + range;

	if e > lengths
		e = lengths;
	end

	[value, index] = max(sounds(s:e)); % get maximum [value, at index] of sound interval(s:e)

	if value > threshold % if this maximum value exceeds threshold:
		maxSound(index+s) = value;
		x(end+1) = index+s;
		y(end+1) = value;
	end
end

x(end+1) = lengths; % push last value: lengths to get last peak
y(end+1) = 0; % push last value: 0 to get last peak

polation = interp1(x, y, 0:max(length(maxSound))); % linear interpolation

subplot(4, 1, 1);
plot(sounds); xl = xlim; yl = ylim; % get limits of x, y axis
subplot(4, 1, 2);
plot(maxSound); xlim(xl); ylim(yl); % set limits of x, y, axis
subplot(4, 1, 3);
plot(polation); xlim(xl); ylim(yl); % set limits of x, y, axis
subplot(4, 1, 4);
findpeaks(polation); xlim(xl); ylim(yl);

[peaks, loc] = findpeaks(polation); %xlim(xl); ylim(yl);  set limits of x, y, axis
for i = 1:length(loc)
    if i == length(loc)
       y = sounds(loc(i)-400:lengths);
    else
        y = sounds(loc(i)-400:loc(i+1)-400);
    end
    N = length(y);
    Y = fft(y);
    Y = 2*Y(1:ceil(N/2));
    f = Fs*(0:(N-1)/2)/N;
    
    figure(2)
    subplot(ceil(length(loc)/2),2,i)
    plot(f,abs(Y/N)); xlim([0 3000]);
    
    figure(3)
    subplot(ceil(length(loc)/2),2,i)
    plot(y)
end
%     title('spectrum')
%     xlabel('frequency');
%     ylabel('magnitude')