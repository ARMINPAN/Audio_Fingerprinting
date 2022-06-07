function score = scoring(list)
    if ~isempty(list) % similarity length != 0
        matched_musics = unique(list(:,1)); % musics which for similarity is found
        score = zeros(length(matched_musics),2); % music name - repetition num
        eps = 0.1;
        for i = 1:length(matched_musics)
            temp = list(list(:,1) == matched_musics(i),:); 
            num = length(temp); % number of repeats for music i
            standard_dev = std(temp(:,2)-temp(:,3))/max(temp(:,2)-temp(:,3));
            score(i, 1) = matched_musics(i); % music name
            % score formula (using repetition num and std of delta ts)
            score(i, 2) = log10(num)*(1-exp((1-num)/10))*(1/(standard_dev+eps)); 
        end

        % transfer through softmax function to get probabilites between 0&1
        score(:, 2) = exp(score(:,2))./sum(exp(score(:,2)));
        % sort based on scores
        [~, permutation] = sort(score(:, 2),'descend');
        score = score(permutation, :);
    else
        fprintf('list cannot be empty');
    end
end