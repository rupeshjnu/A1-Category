function [Projection] = Get_Projection(Animal,CC,Data,DataType,r)
time_epochs = {'stim','delay','rw'};
for tt = 1:size(time_epochs,2)
    [EachClass_Proj] = Project_Trials_freqwise(Animal,CC,Data,time_epochs{tt},DataType,'Test',r);
    for i = 1:size(EachClass_Proj,2)
        Projection.(time_epochs{tt})(:,:,i) = EachClass_Proj{i};
    end
end
end
function [EachClass_Proj] = Project_Trials_freqwise(Animal,CC,Data,Training_time,DataType,WhichTrials,WhichDecoder)
Classes = [4,8,12,16,20,24];
numClasses = size(Classes,2);

if strcmp(Training_time,'stim')
    if size(Data.SpikeCount,2) > 20
        vec = 6:15;
    else
         vec = 4:8;
    end
elseif strcmp(Training_time,'delay')
    if size(Data.SpikeCount,2) > 20
        vec = 21:26;
    else
        vec = 10:14;
    end
elseif strcmp(Training_time,'rw')
    if size(Data.SpikeCount,2) > 20
        vec = 26:36;
    else
        vec = 15:18;
    end
end

[DATA] = GivemeZscore(Data);
SC = DATA.SpikeCount;
numbins = size(CC.w,1);
numTrials = size(SC,1);
num_cvv = size(CC.w,3);

for jj  = 1:6
    EachClass_Proj{jj} = NaN(numbins,num_cvv);
end
    

spont_range = 1:5;
tAxis        = 1:numbins;
xticks       = [1,5,16,26];
xtick_labels = {'-0.5','0','1.1','2.1'};
Spont_fr     = nanmean(squeeze(nanmean(DATA.SpikeCount(:,spont_range,:),2)))';
Spont_fr     = repmat(Spont_fr',[numTrials,1]);
TrialFreq    = Data.Freq;

for cv = 1:num_cvv% loop over all cross validations
      ww = squeeze(nanmean(CC.w(vec,:,cv,WhichDecoder)));
      ww = ww/norm(ww);
 
    for tt = 1:numbins
           XX = squeeze(Data.SpikeCount(:,tt,:));
          [x,y] = find(isnan(XX));
          XY = unique(y);
          if ~isempty(XY)
            Project_class = bsxfun(@minus, squeeze(DATA.SpikeCount(:,tt,:)),Spont_fr); 
          else
           Project_class = bsxfun(@minus, squeeze(DATA.SpikeCount(:,tt,:)),Spont_fr); 
          end
          Projection(:,tt,cv) = ww*Project_class';
    end
end


if strcmp(WhichTrials,'All')

%$$$$$$$$$$$$$$     Project All Trials    $$$$$$$$$$$$$$

    for cc = 1:numClasses
        trials = find(TrialFreq==Classes(cc));
         EachClass_Proj{cc} = squeeze(nanmean(Projection(trials,:,:),1));  
         
    end

elseif strcmp(WhichTrials,'Test')

%$$$$$$$$$$$$$$     Project only Test Trials    $$$$$$$$$$$$$$

    for tt = 1:numbins
        for cvv = 1:num_cvv
            trials = CC.test{1,cvv};
            LL = TrialFreq(trials);
            for cc = 1:numClasses
                trials_cc = trials(find(LL==Classes(cc)));
                if ~isempty(trials_cc)
                   EachClass_Proj{cc}(tt,cvv) = (nanmean(Projection(trials_cc,tt,cvv),1));
                else
                    EachClass_Proj{cc}(tt,cvv) = NaN;
                end
            end
        end
    end
    
    
end
end
