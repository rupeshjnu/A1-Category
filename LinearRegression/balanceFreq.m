function [BFreq,Y] = balanceFreq(LL)
Classes = unique(LL);
NbClass = size(Classes,2);
for i = 1:NbClass
    TT{i} = (LL==Classes(i));
end
[M,idx] = min([sum(TT{1}) sum(TT{2}) sum(TT{3}) sum(TT{4}) sum(TT{5}) sum(TT{6})]);
idxp = setdiff(1:Classes,idx);
Y = [];
for i = 1:NbClass
    if i == idxp
        Y = [Y find(LL==Classes(i))];
    else
        RandTrials = randperm(sum(TT{i}));
        Y1 = find(LL == Classes(i));
        Y = [Y Y1(RandTrials(1:M))];
        
    end
end
BFreq = LL(Y);
end