function SavePopDataSessionwise(RootName,Animal,binsize,SavePathName)
if strcmp(Animal,'Timanoix')
    load([RootName 'SessionInfo_AllSess.mat']);
    load([RootName 'Channels_all.mat']);
    Channels_all{26}.CorrectchId(end) = [];
    Channels_all{26}.Correctch(end) = [];
    params.pre = 0.5;
    params.stim = 1.1;
    params.delay = 1.1;
    params.rw = 0.8;
elseif strcmp(Animal, 'Pelardon')
    load([RootName 'SessionInfo_AllSess.mat']);
    load([RootName 'Channels_all.mat']);
    AllSessions(36:end) = []; % Remove all other experiments 
    params.pre = 0.5;
    params.stim = 1.1;
    params.delay = 1.5;
    params.rw = 1.0;
elseif strcmp(Animal, 'Tomette')
    load([RootName 'SessionInfo.mat']);
    load([RootName 'Channels_all.mat']);
    %AllSessions = Session;
    %AllSessions(4) = [];
    params.pre = 0.5;
    params.stim = 1.1;
    params.delay = 1.0;
    params.rw = 1.0;
end

Behav1 = {'passive','active'};
Behav = {'PrePass','Act'};

for ss = 1:length(AllSessions)
     SC = {[]}; clear Data;
    for j = 1:2
         clear TrialStruct;  X = [];Y= [];
         %disp(['Sess: ' num2str(Sess(ss)) ' Behav: ' Behav{j} '  File: ' AllSessions{Sess(ss)}.(Behav{j})(1:end-2)]);
         load([RootName 'TrialStructures' filesep AllSessions{ss}.(Behav{j})(1:end-2) '_TS.mat']);
         if strcmp(Animal,'Salers')
            [DD] = Get_DataSalers(RootName,AllSessions{ss}.(Behav{j}),params,binsize);
         else
            [DD] = Get_Data(RootName,AllSessions{ss}.(Behav{j}),params,binsize);
         end
         if j ==2
             EarlyTrails = find(strcmp({TrialStruct.Performance},'Early'));
             for tt = 1:length(EarlyTrails)
                 Trial = EarlyTrails(tt);
                 FirstLick = TrialStruct(Trial).Licks(1);
                 if FirstLick >=2.6
                     TrialStruct(Trial).Performance = 'Hit';
                 end
             end
             
             X = [X find(strcmp({TrialStruct.Performance},'Correct Rejection')) find(strcmp({TrialStruct.Performance},'Hit'))];
             Y = [Y find(strcmp({TrialStruct.Performance},'False Alarm')) find(strcmp({TrialStruct.Performance},'Miss'))];
             Data.(Behav1{j}).ErrorFreq = [TrialStruct(Y).Freq];
             Data.(Behav1{j}).ErrorLabel = {TrialStruct(Y).Stim};
         else
             X = 1:length(TrialStruct);
         end
         
         SC{j} = mean(squeeze(sum(DD.SpikeCount(:,:,Channels_all{ss}.CorrectchId),2)));
         Data.(Behav1{j}).SpikeCount = DD.SpikeCount(X,:,Channels_all{ss}.CorrectchId);
         Data.(Behav1{j}).Freq = [TrialStruct(X).Freq];
         Data.(Behav1{j}).Label = {TrialStruct(X).Stim};
    end
    if strcmp(Animal,'Tomette')
        Remove = unique(find(SC{1} < 3));
        Data.passive.SpikeCount(:,:,Remove) = [];
    else
        Remove = [unique([find(SC{1} < 3) find(SC{2} < 3)])];
        Data.passive.SpikeCount(:,:,Remove) = [];
        Data.active.SpikeCount(:,:,Remove) = [];
    end 
    %disp('stop')
    save([SavePathName Animal '_Sess' num2str(ss) 'Data.mat'],'Data');
end
disp( ' Per Session Data generation is done......');
end