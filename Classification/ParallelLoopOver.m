function ParallelLoopOver(Animal,RandNum,A,SavePathName,s)
for r = 1:1
    disp(['Rand Num: ' num2str(r)]);
    clear Pass, clear Act;
    [Pass] = Get_Projection(Animal,A.Classifiers.passive,A.Data.passive,'Passive',r);
    [Act] = Get_Projection(Animal,A.Classifiers.active,A.Data.active,'Active',r);
    PP.passive.stim(:,:,:,r) = Pass.stim;
    PP.passive.delay(:,:,:,r) = Pass.delay;
    PP.passive.rw(:,:,:,r) = Pass.rw;
    PP.active.stim(:,:,:,r) = Act.stim;
    PP.active.delay(:,:,:,r) = Act.delay;
    PP.active.rw(:,:,:,r) = Act.rw;
end
save([SavePathName(1:31) 'Comments1/Fig_2/Results/Projections/SessionWise/' Animal '_Proj_Sessionwise_Sess' num2str(s) '.mat'],'PP');
end