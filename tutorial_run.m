% Demo code for how to use the linear regression mlodels used used in the study 
% Dynamics and maintenance of categorical responses in primary auditory cortex during task engagement 
% by Chillale et al., 2023. 
% 
% This code shows how to build a design matrix based on sensory and category and other task, movement
% events, runs the linear model, shows how to analyze the fitted beta weight
% and quantify cross-validated explained variance
%
% To run, add the repo to your matlab path its location in Matlab.
%%  Get data from Ephhys recording
clear all;

animal = 'Pelardon'; %example animal
Sess = setdiff(1:35,15); 
RootName = ['/Users/rupesh/Dropbox/DATA_NEW/' animal '/Behavior_recording/'];
SavePath = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/eLifeReviews/LRModel/Ephys/';
 binsize = 0.2;
% for rec = 1:35
%     disp(['Session: ' num2str(rec)]);
% %     [PopData] = GetPopDataLR(RootName,animal,binsize,rec);
% %     save([SavePath animal filesep animal '_Data_largebin_sess' num2str(rec) '.mat']);
% 
% %% For generating toydata similar to Pelardon data
%     load([SavePath animal filesep animal '_Data_largebin_sess' num2str(rec) '.mat']);
%     [PopToy] = ToyPelardon(PopData);
%     save([SavePath 'ToyPelardon' filesep 'ToyPelardon_Data_largebin_sess' num2str(rec) '.mat'],'PopToy');
%     
% end

%% Model Fit 
k = 0;
for rec = 1:35 %example recording Session
disp(['Session : ' num2str(rec)]);

% For Animal data use the following
RootName = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/eLifeReviews/LRModel/Ephys/';
fPath = [RootName animal filesep animal '_Data_largebin_sess' num2str(rec) '.mat']; %path to demo recording
load(fPath,'PopData');

% For Toy Model use the following
% fPath = [RootName  'ToyPelardon' filesep 'ToyPelardon_Data_largebin_sess' num2str(rec) '.mat'];
% load(fPath,'PopToy'); % load some options
% PopData = PopToy;
%% Balance Trials
% Freq = unique(PopData.passive.Freq);
% for f = 1:length(Freq)
%     numF(f) = sum(PopData.passive.Freq == Freq(f));
% end
% 
% idx = [];
% minT = min(numF);
% for f = 1:length(Freq)
%     Trials = find(PopData.passive.Freq == Freq(f));
%     randIdx = randperm(length(Trials));
%     idx = [idx Trials(randIdx(1:minT))];
% end
% PopData.passive.Freq = PopData.passive.Freq(idx);
% PopData.passive.SpikeCount = PopData.passive.SpikeCount(idx,:,:);
% PopData.passive.Licks = PopData.passive.Licks(idx);
% PopData.passive.Label = PopData.passive.Label(idx);
%% Full Model
shuff = 'full'; state = 'active';
[full,fullReg] = DesignMatrix(PopData.(state),state,shuff);
[fullV, fullBeta] =  crossValModel_LR(full,fullReg);
     fullV = reshape(fullV,size(PopData.(state).SpikeCount));
      full = reshape(full,size(PopData.(state).SpikeCount));
[fullR2] = explVar(full,fullV);   

%% Shiffle stimulus regressor
shuff = 'sensory';
[sen,senReg] = DesignMatrix(PopData.(state),state,shuff);
[senV, senBeta] =  crossValModel_LR(sen,senReg);
senV = reshape(senV,size(PopData.(state).SpikeCount));
 sen = reshape(sen,size(PopData.(state).SpikeCount));
[senR2] = explVar(sen,senV);   

%% Shiffle cat regressor
shuff = 'category';
[cat,catReg] = DesignMatrix(PopData.(state),state,shuff);
[catV, catBeta] =  crossValModel_LR(cat,catReg);
catV = reshape(catV,size(PopData.(state).SpikeCount));
 cat = reshape(cat,size(PopData.(state).SpikeCount));
[catR2] = explVar(cat,catV); 

NN = k+1:k+size(catR2,1);
a = (fullR2-senR2);
CPD(NN,:,1) = a;
% 
% 
a = (fullR2-catR2);
CPD(NN,:,2) = a;

% CPD(NN,:,1) = fullR2;
% CPD(NN,:,2) = senR2;
% CPD(NN,:,3) = catR2;


%% Active variables 
if strcmp(state,'active')
%% Choice    
    shuff = 'choice';
    [choice,choiceReg] = DesignMatrix(PopData.(state),state,shuff);
    [choiceV, choiceBeta] =  crossValModel_LR(choice,choiceReg);
    choiceV = reshape(choiceV,size(PopData.(state).SpikeCount));
    choice = reshape(choice,size(PopData.(state).SpikeCount));
    [choiceR2] = explVar(choice,choiceV);
 

    a = (fullR2-choiceR2);
    CPD(NN,:,3) = a;
    
%% lick   
    shuff = 'lick';
    [lick,lickReg] = DesignMatrix(PopData.(state),state,shuff);
    [lickV, lickBeta] =  crossValModel_LR(lick,lickReg);
    lickV = reshape(lickV,size(PopData.(state).SpikeCount));
     lick = reshape(lick,size(PopData.(state).SpikeCount));
    [lickR2] = explVar(lick,lickV);
    

    a = (fullR2-lickR2);
    CPD(NN,:,4) = a;
%% Reward  
    shuff = 'reward';
    [reward,rewardReg] = DesignMatrix(PopData.(state),state,shuff);
    [rewardV, rewardBeta] =  crossValModel_LR(reward,rewardReg);
    rewardV = reshape(rewardV,size(PopData.(state).SpikeCount));
     reward = reshape(reward,size(PopData.(state).SpikeCount));
    [rewardR2] = explVar(reward,rewardV);
    
    a = (fullR2-rewardR2);
    CPD(NN,:,5) = a;

    
end

clear PopData;
k = k + size(catR2,1);
end
savePath = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/eLifeReviews/LRModel/Results/';
save([savePath 'ToyPelardon_' state 'CPD.mat' ],'CPD');
%save([savePath animal '_' state 'CPD.mat' ]);
figure;pp = plot(squeeze(mean(CPD,1)),'LineWidth',1);
hold;
line([3,3],[-1,1],'LineStyle','--','Color','k');
line([9,9],[-1,1],'LineStyle','--','Color','k');
ylim([-1 5]*10^(-3));
if size(squeeze(mean(CPD,1)),2) > 2
    lgd = legend(pp,{'Sensory','Category','Choice','Lick','Reward'});
else
    lgd = legend(pp,{'Sensory','Category'});
end

ax =gca;
ax.LineWidth =1;
set(ax,'Fontsize',14);
lgd.FontSize = 12;
legend('boxoff');
ylabel('\Delta cVR^{2}')
xlabel('timebins');
title([animal '-Passive']);

disp('stop')
%% For Active
[spkMat,RegMat] = DesignMatrix(PopData.active,'active');
[Vm, cBeta] =  crossValModel_LR(spkMat,RegMat);


disp('stop')



%% Nested functions


