function plot_Projections(Animal)
SavePathName = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/Fig_2/Results/PopDecode/SessionWiseData/'; 
SavePath = [SavePathName(1:31) 'Comments1/Fig_2/Results/Projections/SessionWise/'];
%% Get All Projections
[IncludeSess] = Get_Sess(Animal);
[PassiveProj,ActiveProj]  = GetAllSessProj(SavePath,Animal,IncludeSess);
  save([SavePath(1:end-12)  Animal '_PassiveRandProj_Sessionwise.mat'],'PassiveProj');
  save([SavePath(1:end-12) Animal '_ActiveRandProj_Sessionwise.mat'],'ActiveProj');
%% Plot Projections

load([SavePath(1:end-12)  Animal '_PassiveRandProj_Sessionwise.mat'],'PassiveProj');
Plot_Proj(PassiveProj,Animal,'passive','Direct',SavePath);

load([SavePath(1:end-12)  Animal '_ActiveRandProj_Sessionwise.mat'],'ActiveProj');
Plot_Proj(ActiveProj,Animal,'active','Direct',SavePath);


end
function  [PassiveProj,ActiveProj]  = GetAllSessProj(SavePath,Animal,IncludeSess)
 disp(['IncludeSess: ' num2str(IncludeSess)]);
 k = 1; 
%   PassiveProj.stim = zeros([36,6,length(IncludeSess),201]);
%  PassiveProj.delay = zeros([36,6,length(IncludeSess),201]);
%     PassiveProj.rw = zeros([36,6,length(IncludeSess),201]);
%    ActiveProj.stim = zeros([36,6,length(IncludeSess),201]);
%   ActiveProj.delay = zeros([36,6,length(IncludeSess),201]);
%      ActiveProj.rw = zeros([36,6,length(IncludeSess),201]);
%      
for i = 1:length(IncludeSess)
    s = IncludeSess(i);
    disp(['Session: ' num2str(s)]);
    clear A;
    A = load([SavePath Animal '_Proj_Sessionwise_Sess' num2str(s) '.mat']);
    RandNum = size(A.PP.passive.stim,4);
    for r = 1:RandNum
        disp(['Rand Num: ' num2str(r)]);
        %clear Pass, clear Act;
           PassiveProj.stim{r}(:,:,k) = squeeze(nanmean(A.PP.passive.stim(:,:,:,r),2));
          PassiveProj.delay{r}(:,:,k) = squeeze(nanmean(A.PP.passive.delay(:,:,:,r),2));
             PassiveProj.rw{r}(:,:,k) = squeeze(nanmean(A.PP.passive.rw(:,:,:,r),2));
            ActiveProj.stim{r}(:,:,k) = squeeze(nanmean(A.PP.active.stim(:,:,:,r),2));
           ActiveProj.delay{r}(:,:,k) = squeeze(nanmean(A.PP.active.delay(:,:,:,r),2));
              ActiveProj.rw{r}(:,:,k) = squeeze(nanmean(A.PP.active.rw(:,:,:,r),2));
    end
    k = k + 1;
end
end
function Plot_Proj(Proj,Animal,WhichState,which,SavePath)
SS = {'stim','delay','rw'};
if strcmp(which,'Direct')
     PP.stim = Proj.stim{1};
    PP.delay = Proj.delay{1};
       PP.rw = Proj.rw{1};
       
elseif strcmp(which,'Rand')
    RandN = size(Proj.stim,2)-1;
         for r = 1:RandN
             clear X;
             for s = 1:3
                X(:,:,:,:,r) = Proj.(SS{s}){r+1};
                PP.(SS{s}) = nanmean(X,5);
             end
         end
    
end
time_epochs = fieldnames(PP);
for tt = 1:size(time_epochs,1)
    plot_PP(Animal,PP.(time_epochs{tt}),time_epochs{tt},WhichState);
    fileName = [SavePath(1:47) 'figures/' Animal '_' which 'Proj_' WhichState '_' time_epochs{tt} '_reftar.png'];
    print_fig(fileName)
end
end
function [Activity,MM] = plot_PP(Animal,PP,Training_time,WhichState)
if strcmp(Training_time,'stim')
    if size(PP,1) > 20
        vec = 6:15;
    else
         vec = 4:8;
    end
elseif strcmp(Training_time,'delay')
    if size(PP,1) > 20
        vec = 21:26;
    else
        vec = 10:14;
    end
elseif strcmp(Training_time,'rw')
    if size(PP,1) > 20
        vec = 26:36;
    else
        vec = 15:18;
    end
end

numClasses = 2%size(PP,2);
numSess = size(PP,3);
numbins = size(PP,1);
tAxis = 1:numbins;
xticks       = [1,5,16,26];
xtick_labels = {'-0.5','0','1.1','2.1'};
idx = {4:6,1:3};
for cc = 1:numClasses
    EachClass_Proj{cc} = squeeze(nanmean(PP(:,idx{cc},:),2));
end

%LineProperties = {rgb('MediumVioletRed'),rgb('PaleVioletRed'),rgb('HotPink'),rgb('Gold'),rgb('DarkGoldenRod'),rgb('GoldenRod')};
LineProperties = {rgb('MediumVioletRed'),rgb('GoldenRod')};

     figure('units','inch','position',[0,0,6,4]);
     plot([5, 5],[-100, 100],'-.k','LineWidth',1)
     hold on
     plot([16, 16],[-100, 100],'-.k','LineWidth',1)
     hold on
     area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[-100 100 -100 100],'LineStyle','none','FaceColor',rgb('Gray'),'FaceAlpha',0.2);
     area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[0 -100 0 -100],'LineStyle','none','FaceColor',rgb('Gray'),'FaceAlpha',0.2);
     plot([0, numbins],[0, 0],'-k','LineWidth',1.5)
     hold on
     
    for cc = 1:numClasses
        HK(cc) = shadedErrorBar1(tAxis,nanmean(EachClass_Proj{cc},2),2*nanstd(EachClass_Proj{cc},[],2)./sqrt(numSess),'lineprops',LineProperties{cc});
        Activity(:,cc) = squeeze(nanmean(EachClass_Proj{cc}(vec,:),1));
    end
        
    xlim([1,numbins]);
    ylim([-0.5,0.5]);
    ax = gca;
    ylabel('Projection','FontName','Times New Roman','FontSize',24)
    xlabel('Time (Sec)','FontName','Times New Roman','FontSize',24)
    set(ax,'FontName','Times New Roman','FontSize',18);
    set(ax,'xtick',xticks,'xtickLabel',xtick_labels);
    set(ax,'TickLength',[0.02,0.002]);
    %lgd = legend([HK.mainLine],{'4','8','12','16','20','24'},'Location','Northeast');
    lgd = legend([HK.mainLine],{' ',' ',' ',' ',' ',' '},'Location','Northeast');
    lgd.FontSize = 18;
    legend('boxoff');
    
%     SavePathName = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/Fig_2/pdf/Classification/'; 
%     fig = gcf;
%     fig.PaperPositionMode = 'auto';
%     fig_pos = fig.PaperPosition;
%     fig.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig,'-dpng', '-r300', [SavePathName Animal '_' WhichState '_Projection_' Training_time '.png']);
% % 
%     [MM] = DistanceMatrix(EachClass_Proj,Training_time);
%     
%     fig = gcf;
%     fig.PaperPositionMode = 'auto';
%     fig_pos = fig.PaperPosition;
%     fig.PaperSize = [fig_pos(3) fig_pos(4)];
%     print(fig,'-dpng', '-r300', [SavePathName Animal '_' WhichState '_ProjectionMatrix_' Training_time '.png'])

end
