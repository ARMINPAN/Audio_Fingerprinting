% Signals & Systems Project - Shazam Implementation

%% load the audio

[audio, Fs] = audioread('music.mp3');

%% mean over right and left headphone & down-sampling

audioMono = mean(audio,1);
Fs_new = 8000;
[Numer, Denom] = rat(Fs_new/Fs);
audioMono = resample(audioMono, Numer, Denom);

%% create the time frequency matrix of the audio using fft

window_time = 0.01;
window_length = window_time*Fs;
window_num = floor(length(audioMono)/(window_length/2));
time_freq_mat = zeros(1+floor(window_length/2),window_num-1);

for i = 1:window_num - 1
    selected_window = audioMono((i-1)*window_length/2+1:(i+1)*window_length/2);
    [f, fft_selected_window] = calFFT(selected_window, Fs);
    time_freq_mat(:,i) = fft_selected_window;
end

%% finding the anchor points on stft using a sliding window

df = floor(0.1*size(time_freq_mat,1));
dt = floor(0.01*size(time_freq_mat,2));
anchor_mat = zeros(size(time_freq_mat));

for i = 1:size(time_freq_mat,1) % freq
    for j = 1:size(time_freq_mat,2) % time
        selected_window = time_freq_mat(max(i-df,1):min(i+df,size(time_freq_mat,1)),...
            max(j-dt,1):min(j+dt,size(time_freq_mat,2)));
        if(time_freq_mat(i,j) == max(selected_window(:)))
            anchor_mat(i,j) = 1;
        end
    end
end



