%% add to path functions
addpath('functions/');

%% create the database
clear; clc; close all;

% Create a database for uploading the key & values finded for each song
database = containers.Map('KeyType','char','ValueType','char');

%% find & add songs' fingerprints to the database
clc;

% Get the name of musics in musics folder in order to process them
% which we have 50 songs here
files = dir(fullfile('musics/','*.mp3'));
[filenames{1:size(files,1)}] = deal(files.name);

% A full screen figure for plots
figure('Units','normalized','Position',[0 0 1 1])

% database musics path
path = 'musics/';

% Go over all songs and find their fingerprints and add them to the database
for k = 1:length(filenames)
    
    disp("Uploading music " + k + " to the database...")
    
    % Import audio 
    [downsampled_Fs, audioMono] = import_audio(path, k);

    % Create the time frequency matrix of the audio using fft and an
    % overlapping sliding window with the length of "window_time"
    window_time = 0.1;
    [time, freq, time_freq_mat] = STFT(audioMono, downsampled_Fs, window_time);
    
    % Plot the stft
    subplot(1,2,1);
    pcolor(time, freq, time_freq_mat);
    axis square
    shading interp
    colorbar;
    xlabel('time(s)','interpreter','latex');
    ylabel('frequency(Hz)','interpreter','latex');
    title("STFT(dB) for music: " + k,'interpreter','latex');

    % Finding the anchor points from time_freq_mat using a sliding window
    % with size of 2dt*2df
    df = floor(0.1*size(time_freq_mat, 1)/4);
    dt = 2/window_time;
    % Function for finding anchor points
    anchor_points = find_anchor_points(time_freq_mat, dt, df);
    % Plot the anchor points
    subplot(1,2,2)
    scatter(time(anchor_points(:, 2)), freq(anchor_points(:, 1)),'x');
    axis square
    xlabel('time(s)','interpreter','latex');
    ylabel('frequency(Hz)','interpreter','latex');
    title("Anchor Points for music: " + k,'interpreter','latex');
    xlim([time(1) time(end)]);
    ylim([freq(1) freq(end)]);
    grid on; grid minor;
close
    % Create the hash table using a window with size of dt*2df for each
    % anchor point
    df_hash = floor(0.1*size(time_freq_mat,1));
    dt_hash = 20/window_time;
    % "create_hash_tags" function creates keys and values for each group of
    % points founded in it
    % Key format: (f1*f2*(t2-t1)) 
    % Value format: (song_name*time_from_start)
    [hash_key, hash_value] = create_hash_tags(anchor_points, df_hash, dt_hash, k);
    % Add key and values founded for this song to the database
    for i = 1:length(hash_key)
        key_tag = [num2str(hash_key(i, 1)), '*', num2str(hash_key(i, 2)), '*', num2str(hash_key(i, 3))];
        if ~(isKey(database, key_tag))
            database(key_tag) = [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))];
        else
            database(key_tag) = [database(key_tag), '+', [num2str(hash_value(i, 1)), '*', num2str(hash_value(i, 2))]];
        end
    end
   
end


% Save the database and musics name in database folder
save('database/database','database');
