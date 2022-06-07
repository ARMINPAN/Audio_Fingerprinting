function [downsampled_Fs, audioMono] = import_audio(path, song_num)

    % Import the audio 
    [audio, Fs] = audioread([path, 'music', num2str(song_num), '.mp3']);

    % Mean over right and left channels since each song has two channels
    audioMono = mean(audio, 2);
    
    % Down sample the song from 44.1 KHz to 8 KHz
    downsampled_Fs = 8000;
    [Numer, Denom] = rat(downsampled_Fs/Fs);
    audioMono = resample(audioMono, Numer, Denom);
end