function [IncludeSess] = Get_Sess(Animal)
SavePathName = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/Fig_2/Results/PopDecode/SessionWiseData/'; 
if strcmp(Animal,'Pelardon')
    Sess = setdiff(1:35,15); 
    Th = 30;
elseif strcmp(Animal,'Timanoix')
    Sess = setdiff(2:38,[29,32]);
    Th = 30;
elseif strcmp(Animal,'Tomette')
     Sess = 1:9;
     Th = 30;
elseif strcmp(Animal,'Salers')
     Sess = 1:23;
     Th = 25;
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
end