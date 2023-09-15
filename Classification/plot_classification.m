function [DD] = plot_classification(PathName,Animal,IncludeSess)
k = 1;
for s =  IncludeSess
    clear Classifiers;
    load([PathName Animal '_Classifiers_Sess' num2str(s) '.mat']);
    disp([ 'Session: ' num2str(s) ' Number of Neurons: ' num2str( size(Classifiers.passive.w,2))]);
    CC.passive.Perf(k,:,:,:) = Classifiers.passive.Perf;
    CC.active.Perf(k,:,:,:) = Classifiers.active.Perf;
    k = k+1;
end
 DD.passive.Perf = squeeze(nanmean(CC.passive.Perf,2));
 DD.active.Perf = squeeze(nanmean(CC.active.Perf,2));
end