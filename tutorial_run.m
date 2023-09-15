% Demo code for Population decoding and multiple linear regression models used used in the study 
% Dynamics and maintenance of categorical responses in primary auditory cortex during task engagement 
% by Chillale et al., 2023. 
% Download the data from Zendo and run the following to reproduce the some
% of the figures mentioned in the paper.

% Pelardon and Timanoix corresponds to Ferret 1 and Ferret 2 in the paper
%% Generate Fig-1e
animals = {'Pelardon','Timanoix'}; %animals
% Change the working directory to the downloaded folder
fPath = pwd;
addpath([fPath '/MISC/']);
addpath([fPath '/PopDecode/']);
Contrast.passive = [];
 Contrast.active = [];
         binsize = 0.1;
 PopDataPath = [fPath filesep 'PopDecode' filesep 'PopData' filesep];      
for i = 1:length(animals)
    RootName = [fPath filesep 'Data' filesep animals{i} filesep];
    [IncludeSess,params,AllSessions] = Get_Sess(RootName,animals{i});
    
    % useful for population decoding
    SavePopDataSessionwise(RootName,animals{i},binsize,PopDataPath);
    
    load([RootName 'AllClicks_all.mat']);
    [activity] = create_contrast(animals{i},RootName,IncludeSess,AllSessions,params,binsize,'Correct'); % last argument is binsize
    Contrast.passive = cat(2,Contrast.passive,activity.passive);
    Contrast.active = cat(2,Contrast.active,activity.active);
end
plot_contrast(Contrast);
%% Population decoding Fig-2a
Animal = 'Pelardon';
DataPath = [fPath '\PopDecode\PopData\'];
SavePath = [fPath '\PopDecode\Results\'];
[IncludeSess,~,~] = Get_PopDecodeSess(Animal,DataPath);
for s = IncludeSess
    clear Data; clear Data1;
    load([DataPath Animal '_Sess' num2str(s) 'Data.mat']);
    disp(['---------Sess : ' num2str(s) '  -----------']);
    [Classifiers] = Perform_Classification(Animal,Data);
    save([SavePath Animal '_Classifiers_Sess' num2str(s) '.mat'],'Classifiers','Data');
end

[CC] = plot_classification(SavePath,Animal,IncludeSess);
plot_Perf(CC.active.Perf(:,:,1),CC.passive.Perf(:,:,1),CC.active.Perf(:,:,2),{rgb('Red'),rgb('Blue'),rgb('Black')});
%% Linear Regression
%% Get Sessionwise Population Data
addpath([fPath '\LinearRegression\']);
Animal = 'Pelardon';
DataPath = [fPath '\PopDecode\PopData\'];
RootName = [fPath filesep 'Data' filesep Animal filesep];
SaveData = [fPath '\LinearRegression\PopData\'];
[~,TotalSess,~] = Get_PopDecodeSess(Animal,DataPath);
for s = 1:TotalSess
    disp(['Session: ' num2str(s)]);
    [PopData] = GetPopData(RootName,Animal,0.2,s);
    save([SaveData Animal '_Data_largebin_sess' num2str(s) '.mat'],'PopData');
end

%% Perform the Linear Regresson
DataPath = [fPath '\LinearRegression\PopData\'];
SavePath = [fPath '\LinearRegression\Results\'];
RandShuff = 0; % For fast computation, in the manuscript, RandShuff = 100.
 for s = 1:TotalSess
    disp(['Session: ' num2str(s)]);
    load([DataPath Animal '_Data_largebin_sess' num2str(s) '.mat']);
    if ~isempty(PopData.active.Correct.SpikeCount)
        for i = 1: RandShuff + 1
            if i == 1
                X = PopData.passive;Y = PopData.active.Correct;
            else
                RandTrials1 = randperm(size(PopData.passive.SpikeCount,1));
                PopData.passive.SpikeCount = PopData.passive.SpikeCount(RandTrials1,:,:,:);
                X = PopData.passive;Y = PopData.active.Correct;
            end
            disp('..........Passive ..........');
            [Regressors.passive{i}] = Fit_RidgeRegression(X);
            disp('..........Active ..........');
            [Regressors.active{i}] = Fit_RidgeRegression(Y);
            save([SavePath Animal '_Regression_WithBalanceData_sess' num2str(s) '.mat'],'Regressors','PopData');
        end
    end
 end
%% 
DataPath = [fPath '\PopDecode\PopData\'];
[~,~,Range] = Get_PopDecodeSess(Animal,DataPath); 
[CPD] = Compute_CPD(SavePath,Animal,Range,1);

Color_Prop = {rgb('Indigo'),rgb('DarkGreen'),rgb('Black')};
plot_CPD(CPD.passive,Color_Prop,{'Sensory','Cateory'});
plot_CPD(CPD.active,Color_Prop,{'Sensory','Cateory'});



