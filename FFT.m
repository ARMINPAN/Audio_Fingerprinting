function fft_X = FFT(X, Fs)
    L = length(X);
    Y = fft(X); 
    fft_X = (abs(Y).^2)/L;
    fft_X = fft_X(1:floor(L/2)+1);
    fft_X(2:end-1) = 2*fft_X(2:end-1);
end