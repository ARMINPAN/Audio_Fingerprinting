function [time, freq, time_freq_mat] = STFT(audio, Fs, window_time)
    window_length = Fs*window_time;
    window_num = floor(length(audio)/(window_length/2));
    time_freq_mat = zeros(1+floor(window_length/2),window_num-1);
    for i = 1:window_num-1
        selected_window = audio((i-1)*window_length/2+1:(i+1)*window_length/2);
        fft_selected_window = FFT(selected_window, Fs);
        time_freq_mat(:, i) = pow2db(fft_selected_window+0.001);
    end
    time = (window_time/2)*(1:(window_num-1));
    freq = Fs*(0:floor(window_length/2))/window_length;
end