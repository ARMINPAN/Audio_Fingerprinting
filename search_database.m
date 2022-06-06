%% load the created database
clear; close all; clc;

database = load('database/database.mat').database;

%% calculate the hash value for the given song

% load the audio
[audio, Fs] = audioread('test_musics/music1.mp3');

start_time = randi([1 0.9*length(audio)]);
selected_audio = audio(start_time:start_time+0.1*length(audio),:);

% mean over right and left headphone & down-sampling
audioMono = mean(selected_audio, 2);
downsampled_Fs = 8000;
[Numer, Denom] = rat(downsampled_Fs/Fs);
audioMono = resample(audioMono, Numer, Denom);

% create the time frequency matrix of the audio using fft
window_time = 0.1;
[time, freq, time_freq_mat] = STFT(audioMono, downsampled_Fs, window_time);
figure();
pcolor(time, freq, time_freq_mat);
shading interp
colorbar;
xlabel('time(s)');
ylabel('frequency(Hz)');
title('STFT(dB)');

% finding the anchor points on stft using a sliding window
df = floor(0.1*size(time_freq_mat, 1));
dt = 5/window_time;
anchor_points = find_anchor_points(time_freq_mat, df, dt);
figure();
scatter(time(anchor_points(:, 2)), freq(anchor_points(:, 1)),'x');
xlabel('time(s)','interpreter','latex');
ylabel('frequency(Hz)','interpreter','latex');
title("anchor points",'interpreter','latex');
xlim([time(1) time(end)]);
ylim([freq(1) freq(end)]);
grid on; grid minor;

% create the hash value
df_hash = floor(0.1*size(time_freq_mat,1));
dt_hash = 20/window_time;
[hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, 0);

%% search hash tags
clc; close all;

list = []; 

for i = 1:length(hash_key)
    key_tag = [num2str(hash_key(i, 1)), '*', num2str(hash_key(i, 2)), '*', num2str(hash_key(i, 3))];
    if (isKey(database, key_tag))
        temp1 = split(database(key_tag),'+');
        for j = 1:length(temp1)
            temp2 = split(temp1{j},'*');
            list = [list; [str2num(temp2{1}),str2num(temp2{2}),hash_value(i,2)]];
        end
    end
end

%% scoring
clc; close all;

scoring(list,window_time)


