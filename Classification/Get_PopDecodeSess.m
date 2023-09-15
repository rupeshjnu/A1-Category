function [IncludeSess,TotalSess,Range] = Get_PopDecodeSess(Animal,SavePathName)
if strcmp(Animal,'Pelardon')
    Sess = setdiff(1:35,15); 
    Th = 30;
    TotalSess = 35;
    Range = 1:TotalSess;
elseif strcmp(Animal,'Timanoix')
    Sess = setdiff(2:38,[29,32]);
    Th = 30;
    TotalSess = 39;
    Range = setdiff(1:TotalSess,3);
elseif strcmp(Animal,'Tomette')
     Sess = 1:9;
     Th = 30;
     TotalSess = 7;
     Range = 1:TotalSess;
end


%----- Perform Classification per session ------
IncludeSess = [];
for s = Sess
    load([SavePathName Animal '_Sess' num2str(s) 'Data.mat']);
    if strcmp(Animal,'Tomette')
        TarNb = sum(strcmp(Data.passive.Label,'Target'));
    else
        TarNb = sum(strcmp(Data.active.Label,'Target'));
    end
    if TarNb >= Th
        NN = size(Data.passive.SpikeCount,3);
        if (NN > 1)
            IncludeSess = [IncludeSess s];
        end
    end
end