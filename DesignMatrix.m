function [spk,RegMat] = DesignMatrix(Data,state,Shuff)
%%
spk = Data.SpikeCount;
spk = reshape(spk,[],size(spk,3),1);
spk = bsxfun(@minus, spk', mean(spk)')';
%% Stimulus
stim = Data.Freq';
stim = repmat(stim,1,size(Data.SpikeCount,2));
stim = reshape(stim,size(stim,1)*size(stim,2), 1);
stim = bsxfun(@minus,stim,mean(stim));
stim = bsxfun(@rdivide,stim,std(stim));
%% Category
cat(strcmp(Data.Label,'Reference')) = 0;
cat(strcmp(Data.Label,'Target')) = 1;
cat = cat';
cat = repmat(cat,1,size(Data.SpikeCount,2));
cat = reshape(cat,size(cat,1)*size(cat,2), 1);

cat = bsxfun(@minus,cat,mean(cat));
cat = bsxfun(@rdivide,cat,std(cat));
 
%% Choice
if strcmp(state,'active')
choice(strcmp(Data.Perf,'Correct Rejection')) = 1;
choice(strcmp(Data.Perf,'False Alarm')) = 2;
choice(strcmp(Data.Perf,'Miss')) = 3;
choice(strcmp(Data.Perf,'Early')) = 4;
choice(strcmp(Data.Perf,'Hit')) = 5;
choice = choice';
choice = repmat(choice,1,size(Data.SpikeCount,2));
choice = reshape(choice,size(choice,1)*size(choice,2), 1);

choice = bsxfun(@minus,choice,mean(choice));
choice = bsxfun(@rdivide,choice,std(choice));
%% Lick
if size(Data.SpikeCount,2) == 18
    time_bins = [0:0.16666:0.5 0.72:0.22:1.6 1.8:0.2:3.6];
else
    time_bins = 0:0.1:3.6;
end

nTrials = size(Data.SpikeCount,1);

for i = 1:nTrials
    Licks = Data.Licks{i};
    Licks = Licks(Licks > 0.5);
    if ~isempty(Licks)
        for k=1:length(time_bins)-1
            lickpst(i,k) = sum(Licks<=time_bins(k+1) & Licks>time_bins(k));
        end
    else
        lickpst(i,:) = zeros(length(time_bins)-1,1);
    end
end

lickpst= reshape(lickpst,size(lickpst,1)*size(lickpst,2), 1);

lickpst = bsxfun(@minus,lickpst,mean(lickpst));
lickpst = bsxfun(@rdivide,lickpst,std(lickpst,1));

%% Reward or punishment
reward(strcmp(Data.Perf,'Correct Rejection')) = 1;
reward(strcmp(Data.Perf,'False Alarm')) = 0;
reward(strcmp(Data.Perf,'Miss')) = 0;
reward(strcmp(Data.Perf,'Early')) = 0;
reward(strcmp(Data.Perf,'Hit')) = 1;

reward = repmat(reward,1,size(Data.SpikeCount,2));
reward = reshape(reward,size(reward,1)*size(reward,2), 1);

reward = bsxfun(@minus,reward,mean(reward));
reward = bsxfun(@rdivide,reward,std(reward));

%% full Regressor Matrix
if strcmp(Shuff,'sensory')
    randIdx = randperm(length(stim));
    stim = stim(randIdx);
elseif strcmp(Shuff,'category')
    randIdx = randperm(length(cat));
    cat = cat(randIdx);
elseif strcmp(Shuff,'choice')
    randIdx = randperm(length(choice));
    choice = choice(randIdx);
elseif strcmp(Shuff,'lick')
    randIdx = randperm(length(lickpst));
    lickpst = lickpst(randIdx);
elseif strcmp(Shuff,'reward')
    randIdx = randperm(length(reward));
    reward = reward(randIdx);
end


%RegMat = [stim cat choice lickpst reward];
RegMat = [stim cat choice lickpst reward];
RegMat = bsxfun(@minus, RegMat, mean(RegMat, 1));
else
    if strcmp(Shuff,'sensory')
        randIdx = randperm(length(stim));
        stim = stim(randIdx);
    elseif strcmp(Shuff,'category')
        randIdx = randperm(length(cat));
        cat = cat(randIdx);
    end
    
    RegMat = [stim cat];
    RegMat = bsxfun(@minus, RegMat, mean(RegMat, 1));
    
   
end