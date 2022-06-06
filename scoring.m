function score = scoring(list)
    if isempty(list) == 0
        matched_musics = unique(list(:,1));
        score = zeros(length(matched_musics),2); % music - score
        eps = 0.1;
        for i = 1:length(matched_musics)
            temp = list(list(:,1) == matched_musics(i),:);
            num = length(temp);
            standard_dev = std(temp(:,2)-temp(:,3))/max(temp(:,2)-temp(:,3));
            score(i, 1) = matched_musics(i);
            score(i, 2) = (1-exp((1-num)/5))*(1/(standard_dev+eps));
        end

        % transfer through softmax function
        score(:, 2) = exp(score(:,2))./sum(exp(score(:,2)));
    else
        fprintf('list cannot be empty');
    end
    [~, permutation] = sort(score(:, 2),'descend');
    score = score(permutation, :);
end