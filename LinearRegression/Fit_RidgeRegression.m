function [Regressors] = Fit_RidgeRegression(DATA)

Ref = strcmp(DATA.Label,'Reference');
Tar = strcmp(DATA.Label,'Target');
% Regressors 
F(1,:) = [DATA.Freq];
F(2,Ref) = -1;
F(2,Tar) = 1;

rng(3); % For reproduction

flags = {1:2;2;1;1:2;1:2;1:2}; 
flags_id = {'FM','M1','M2','M3','M4','M5'};  

HowManyFold = 5;
indices = crossvalind('Kfold',length(F(1,:)),HowManyFold);
for cvv = 1:HowManyFold
    test = find(indices == cvv);
    train1 = setdiff(1:size(F(1,:),2),test);
    [~,Y] = balanceFreq(DATA.Freq(train1));
    train = train1(Y);
    TrainTrials{cvv} = train;
    TestTrials{cvv} = test;
    
    
    for tt = 1:size(DATA.SpikeCount,2)
        %disp(['tt: ' num2str(tt)]);
        X = squeeze(DATA.SpikeCount(:,tt,:));
        for m = 1:size(flags,1)
            %disp(['Model: ' flags_id{m}]);
            if m == 4 || m ==5
                F1 = F(flags{m},:);
                RandTrails = randperm(size(F,2));
                F1(m-3,:) = F(m-3,RandTrails);
            elseif m ==6
                F1 = F(flags{m},:);
                for ij = 1:2
                    RandTrails = randperm(size(F,2));
                    F1(ij,:) = F(ij,RandTrails);
                end
            else
                F1 = F(flags{m},:);
            end
            
            clear beta_cap; clear rcap; clear Error;
                
                if cvv == 1
                    [L{m,tt},beta_cap] = ridgeMML(X(train,:), F1(:,train)',1);
                else
                    [~,beta_cap] = ridgeMML(X(train,:), F1(:,train)',1,L{m,tt});
                end
                
                F_test = F1(:,test);F_test = bsxfun(@minus,F_test,mean(F_test,2));
                rcap = F_test' * beta_cap;
                
                BB.(flags_id{m})(:,:,tt,cvv) = beta_cap;
           
            
            Error = X(test,:) - rcap;
            MSE.(flags_id{m})(tt,cvv,:)  = var(Error);
            
        end
    end
end
 

 Regressors.Betas = BB;
 Regressors.MSE = MSE;
 Regressors.TestTrials = TestTrials;
 Regressors.TrainTrials = TrainTrials;
 
 disp('Finished Ridge Regression .........')
 
end