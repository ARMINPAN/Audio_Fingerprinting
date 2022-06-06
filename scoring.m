function final_score = scoring(list,window_time)
    matched_musics = unique(list(:,1));
    score_table = zeros(length(matched_musics),3); % music num - repeat - variance
    final_score = zeros(length(matched_musics),2); % music num - score
    eps = 0.1;
    for i = 1:length(matched_musics)
        temp = list(list(:,1) == matched_musics(i),:);
        score_table(i,1) = matched_musics(i);
        score_table(i,2) = length(temp);
        score_table(i,3) = std(temp(:,2)-temp(:,3))/max(temp(:,2)-temp(:,3))
        final_score(i,1) = score_table(i,1);
        final_score(i,2) = (1/(score_table(i,3)+eps))*(1-exp((1-score_table(i,2))/5));
    end
    
    % transfer through softmax function
    final_score(:,2) = exp(final_score(:,2))./sum(exp(final_score(:,2)));
end