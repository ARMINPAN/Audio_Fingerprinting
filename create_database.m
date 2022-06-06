%% create the database
clear; clc; close all;

database = containers.Map('KeyType','char','ValueType','char');

%% 
files = dir(fullfile('musics/','*.mp3'));
[filenames{1:size(files,1)}] = deal(files.name);

% go over all songs
for k = 1:1%length(filenames)
    music = k
    
    % load the audio
    [audio, Fs] = audioread(['musics/music', num2str(k), '.mp3']);

    % mean over right and left headphone & down-sampling
    audioMono = mean(audio, 2);
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
    title("anchor points for music: " + k,'interpreter','latex');
    xlim([time(1) time(end)]);
    ylim([freq(1) freq(end)]);
    grid on; grid minor;

    % creating hash tags

    df_hash = floor(0.1*size(time_freq_mat,1));
    dt_hash = 20/window_time;
    [hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, 2);
    for i = 1:length(hash_key)
        key_tag = [num2str(hash_key(i, 1)), '*', num2str(hash_key(i, 2)), '*', num2str(hash_key(i, 3))];
        if ~(isKey(database, key_tag))
            database(key_tag) = [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))];
        else
            database(key_tag) = [database(key_tag), '+', [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))]];
        end
    end
end

save('database/database','database');