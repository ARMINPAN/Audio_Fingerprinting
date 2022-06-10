function fft_X = FFT(X)
    L = length(X);
    % fft of the signal
    fft_X = fft(X);
    % get magnitude of the components
    fft_X = (abs(fft_X)/L).^2;
    % one-sided spectrum
    fft_X = fft_X(1:floor(L/2)+1);
    fft_X(2:end-1) = 2*fft_X(2:end-1);
end