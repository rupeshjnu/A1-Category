function [CPD] = Compute_CPD(SavePathName,Animal,Range,ii)
BB = {'passive','active'};
 k = 0;
for s = Range
    clear Regressors;
     load([SavePathName Animal '_Regression_WithBalanceData_sess' num2str(s) '.mat']);
     numN = size(Regressors.passive{1}.Betas.FM,2);
     idx = k+1:k+numN;
     k = k + numN;
    for b = 1:size(BB,2)
        FM = Regressors.(BB{b}){ii}.MSE.FM;
        M1 = Regressors.(BB{b}){ii}.MSE.M3;
        M2 = Regressors.(BB{b}){ii}.MSE.M4; 
        
        for n = 1:numN
            Full = mean(FM(:,:,n),2);
            Red1 = mean(M1(:,:,n),2);
            Red2 = mean(M2(:,:,n),2);
            CPD.(BB{b})(:,idx(n),1) = (Red1-Full)./Red1;
            CPD.(BB{b})(:,idx(n),2) = (Red2-Full)./Red2;
        end    
    end
end
end