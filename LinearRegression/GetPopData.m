function [Data] = GetPopData(RootName,Animal,binsize,Sess)
Cat = [4,8,12,16,20,24];
if strcmp(Animal,'Timanoix')
    load([RootName 'SessionInfo_RecSess.mat']);
    load([RootName 'Channels_all.mat']);
    Channels_all{26}.CorrectchId(end) = [];
    Channels_all{26}.Correctch(end) = [];
    params.pre = 0.5;
    params.stim = 1.1;
    params.delay = 1.1;
    params.rw = 0.8;
    Cat_idx = {'Target','Target','Target','Reference','Reference','Reference'};
    Perf.Correct = {'Hit','Hit','Hit','Correct Rejection','Correct Rejection','Correct Rejection'};
    Perf.Error = {'Miss','Miss','Miss','False Alarm','False Alarm','False Alarm'};
elseif strcmp(Animal, 'Pelardon') || strcmp(Animal, 'Tomette')
    load([RootName 'SessionInfo_AllSess.mat']);
    load([RootName 'Channels_all.mat']);
    AllSessions(36:end) = [];
    params.pre = 0.5;
    params.stim = 1.1;
    params.delay = 1.5;
    params.rw = 1.0;
    Cat_idx = {'Reference','Reference','Reference','Target','Target','Target'};
    Perf.Correct = {'Correct Rejection','Correct Rejection','Correct Rejection','Hit','Hit','Hit'};
    Perf.Error = {'False Alarm','False Alarm','False Alarm','Miss','Miss','Miss'};
    
end

if strcmp(Animal,'Tomette')
    Behav1 = {'passive'};
    Behav = {'PrePass'};
else
    Behav1 = {'passive','active'};
    Behav = {'PrePass','Act'};
end


for j = 1:size(Behav1,2)
    clear TrialStruct; 
    load([RootName 'TrialStructures' filesep AllSessions{Sess}.(Behav{j})(1:end-2) '_TS.mat']);
    [DD] = Get_Data(RootName,AllSessions{Sess}.(Behav{j}),params,binsize);    
    X = [];Y = [];
    if j == 2
       EarlyTrails = find(strcmp({TrialStruct.Performance},'Early'));
       for tt = 1:length(EarlyTrails)
           Trial = EarlyTrails(tt);
           FirstLick = TrialStruct(Trial).Licks(1);
           if FirstLick >=2.6
               TrialStruct(Trial).Performance = 'Hit';
           end
       end
         
       for f = 1:length(Cat)
           FreqTrials = find([TrialStruct.Freq] == Cat(f));
           X = [X FreqTrials(strcmp({TrialStruct(FreqTrials).Performance},Perf.Correct{f}))];
           Y = [Y FreqTrials(strcmp({TrialStruct(FreqTrials).Performance},Perf.Error{f}))];
       end
       
        Data.(Behav1{j}).Correct.SpikeCount = DD.SpikeCount(X,:,Channels_all{Sess}.CorrectchId);
        Data.(Behav1{j}).Correct.Freq = [TrialStruct(X).Freq];
        Data.(Behav1{j}).Correct.Label = {TrialStruct(X).Stim};
        Data.(Behav1{j}).Correct.Sess(1:length(Channels_all{Sess}.CorrectchId)) = Sess;
        
        Data.(Behav1{j}).Error.SpikeCount = DD.SpikeCount(Y,:,Channels_all{Sess}.CorrectchId);
        Data.(Behav1{j}).Error.Freq = [TrialStruct(Y).Freq];
        Data.(Behav1{j}).Error.Label = {TrialStruct(Y).Stim};
        Data.(Behav1{j}).Error.Sess(1:length(Channels_all{Sess}.CorrectchId)) = Sess;
       
    else
        
        for f = 1:length(Cat)
           FreqTrials = find([TrialStruct.Freq] == Cat(f));
           X = [X FreqTrials];
        end
       
        Data.(Behav1{j}).SpikeCount = DD.SpikeCount(X,:,Channels_all{Sess}.CorrectchId);
        Data.(Behav1{j}).Freq = [TrialStruct(X).Freq];
        Data.(Behav1{j}).Label = {TrialStruct(X).Stim};
        Data.(Behav1{j}).Sess(1:length(Channels_all{Sess}.CorrectchId)) = Sess;

    end
    SC{j} = mean(squeeze(sum(DD.SpikeCount(:,:,Channels_all{Sess}.CorrectchId),2)));
        
end

%%.... Removing neurons with less than 1 Hz firing rate ........
if strcmp(Animal,'Tomette')
    Remove = unique(find(SC{1} < 3));
    Data.passive.SpikeCount(:,:,Remove) = [];
else
    Remove = [unique([find(SC{1} < 3) find(SC{2} < 3)])];
    Data.passive.SpikeCount(:,:,Remove) = [];
    Data.active.Correct.SpikeCount(:,:,Remove) = [];
    Data.active.Error.SpikeCount(:,:,Remove) = [];
end

%disp(['Session: ' num2str(ss) ' Remove Neurons: ' num2str(Remove)]);
%disp([ 'Session:' num2str(Sess) ' Numner of Neurons: ' num2str(length(Channels_all{Sess}.Correctch))]);
end