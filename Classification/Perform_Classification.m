function [Classifier] = Perform_Classification(Animal,Data)
Behav = {'passive','active'};
for bh = 1:2
    clear SC;
    SC = Data.(Behav{bh}).SpikeCount;

Fold_sh = 1;
% Cross Validation 
for sh = 1:Fold_sh+1
    clear Labels;
     disp(['------- Shuffling num:' num2str(sh) '-------------']);
    % For first iteration, no shuffling
    if sh == 1
        Labels = Data.(Behav{bh}).Label;
        [Decoder] = PopDecode(SC,Labels);
    else
        RandTrials = randperm(size(SC,1));
        Labels = Data.(Behav{bh}).Label;
        SC = SC(RandTrials,:,:);
        [Decoder] = PopDecode(SC,Labels);
    end
    Classifier.(Behav{bh}).train(sh,:) = Decoder.train;
    Classifier.(Behav{bh}).test(sh,:) = Decoder.test;
    Classifier.(Behav{bh}).w(:,:,:,sh) = Decoder.w;
    Classifier.(Behav{bh}).b(:,:,sh) = Decoder.b;
    Classifier.(Behav{bh}).Perf(:,:,sh) = Decoder.Perf;
end
disp('Finished Population Decoding ........');
end
end
function [Classifier] = PopDecode(SC,Labels)
warning off; dbstop if error;
Classes = unique(Labels);
NbClass = size(Classes,2);
ClassComnts = [1,2];
TotalTrials = size(Labels,2);
HowManyFold = 200;
Performance    = NaN(HowManyFold,size(SC,2));
for cvv = 1:HowManyFold  % Each time point 

%%.......  200 cross validation for already balanced data......................
   indices = crossvalind('Resubstitution',TotalTrials,[0.7,0.3]);
   test = find(indices);
   test = test';
   train = setdiff(1:TotalTrials,test);
     
   Ref_train = train(strcmp(Labels(train),'Reference'));
   Tar_train = train(strcmp(Labels(train),'Target'));
   
   MM = min(length(Ref_train),length(Tar_train));
   Ref_train = Ref_train(1:MM);
   Tar_train = Tar_train(1:MM);
%%................................................................   

    Pop_V1 = squeeze(nanmean(SC(Ref_train,:,:),1));
    Pop_V2 = squeeze(nanmean(SC(Tar_train,:,:),1));
    
    ww = Pop_V2 - Pop_V1;
    bb = (dot(ww',Pop_V1')+dot(ww',Pop_V2'))/2;
    Pop_Test = squeeze(SC(test,:,:));
    Nonemptytrials = []; TestClass_True = []; Class_predict = []; 
    for jj = 1:size(Pop_Test,1)
        ZZ = squeeze(Pop_Test(jj,:,:))';
        Z1 = find(isnan(ZZ));
        if ~isempty(Z1)
            Nonemptytrials = [Nonemptytrials jj];
        end
        Projections(jj,:) = diag(ww*squeeze(Pop_Test(jj,:,:))');           
        TestClass_True(jj,1:size(SC,2)) = find(strcmp(Classes,(Labels(test(jj)))));         
    end
    
    test(Nonemptytrials) = [];
    Projections(Nonemptytrials,:) = [];
    TestClass_True(Nonemptytrials,:) = [];
    
    
    cluster = bsxfun(@lt,Projections,bb);
    k = ClassComnts(bsxfun(@plus,cluster,(1:2:2*size(ClassComnts,1))));
    Class_predict =[];
    for ii=1:length(test)
        for tt = 1:size(SC,2)
            Class_predict(ii,tt) = setdiff(1:length(Classes),k(ii,tt));
        end
    end
    Performance(cvv,:) = squeeze(sum(TestClass_True == Class_predict)./(size(test,2)));
    
    
%Return variable
Classifier.train{cvv} = train;
Classifier.test{cvv} = test;
Classifier.Projection{cvv} = Projections;
Classifier.w(:,:,cvv) = ww;
Classifier.b(:,cvv) = bb;
Classifier.Perf = Performance;
end
end