function [Data] = BalanceTrials(DD)

States = fieldnames(DD);

for s = 1:size(States,1)
    
    LL = DD.(States{s}).Label;
    
    [~,idx] = balanceLabels(LL);
    
    Data.(States{s}).SpikeCount = DD.(States{s}).SpikeCount(idx,:,:);
    
    Data.(States{s}).Label = DD.(States{s}).Label(idx);
    
    Data.(States{s}).Freq  = DD.(States{s}).Freq(idx);
    
end

end

function [BLabel,Y] = balanceLabels(LL)

Classes = unique(LL);

NbClass = size(Classes,2);

for i = 1:NbClass
    
    TT{i} = strcmp(LL,Classes(i));
    
end

[M,idx] = min([sum(TT{1}) sum(TT{2})]);

idxp = setdiff(1:2,idx);

RandTrials = randperm(sum(TT{idxp}));

Labels = []; Y = [];%zeros(1,size(LL,2));

for i = 1:NbClass
    
    Y1 = find(strcmp(LL,Classes(i)));
    
    X = LL(Y1);
    
    if i == idxp
        
        Y = [Y Y1(RandTrials(1:M))];
        
        BLabel = [Labels LL(Y)];
        
    else
        
        BLabel = [Labels X];
        
        Y = [Y Y1];
        
    end
    
end

end