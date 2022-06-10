function [downsampled_Fs, audioMono] = import_audio(path, song_num)
    % import the audio 
    [audio, Fs] = audioread([path, 'music', num2str(song_num), '.mp3']);
    % getting mean over right and left channels
    audioMono = mean(audio, 2);
    % downsample the audio to 8 KHz
    downsampled_Fs = 8000;
    [Numer, Denom] = rat(downsampled_Fs/Fs);
    audioMono = resample(audioMono, Numer, Denom);
end