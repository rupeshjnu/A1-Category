function [DATA_ZScore] = GivemeZscore(DATA)
    DATA_ZScore = DATA;
    for tt= 1:size(DATA.SpikeCount,2)
        X = squeeze(DATA.SpikeCount(:,tt,:));
        meanX = mean(X,1);
        stdX = std(X,[],1);
        X = bsxfun(@minus,X, meanX);
        %DATA_ZScore.SpikeCount(:,tt,:) = X; 
        DATA_ZScore.SpikeCount(:,tt,:) = bsxfun(@rdivide,X,stdX);
        % Check for zero Variance 
        if ~isempty(find(stdX == 0))
            DATA_ZScore.SpikeCount(:,tt,find(stdX == 0)) = 0;
        end
    end
end