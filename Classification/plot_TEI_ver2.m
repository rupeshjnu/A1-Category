function plot_TEI_ver2(Animal)
Color_Prop = {rgb('OrangeRed'),rgb('Black')};
[All_Projections] = SaveAllProjections(Animal,'OnDecoder');
dp = All_Projections.passive;
%dp = dp(:,:,[1:14 16:end]);
da = All_Projections.active;
%da = da(:,:,[1:14 16:end]);
[timesteps,stimnb,sessionnb] = size(da);

if strcmp(Animal,'Pelardon')
    REF = 1:3;TAR = 4:6;
elseif strcmp(Animal,'Timanoix') || strcmp(Animal,'Salers')
    REF = 4:6;TAR = 1:3;
end

refa = squeeze(mean(da(:,REF,:),2));
tara = squeeze(mean(da(:,TAR,:),2));
refp = squeeze(mean(dp(:,REF,:),2));
tarp = squeeze(mean(dp(:,TAR,:),2));

vec = 4:8;
tAxis = 1:size(mean(refa,2),1);
% plot target and reference projections in active passive
figure('units','inch','position',[0,0,5,6]);
subplot(2,1,1); hold all; clear p
area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[-100 100 -100 100],'LineStyle','none','FaceColor',rgb('DarkGreen'),'FaceAlpha',0.2);
area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[0 -100 0 -100],'LineStyle','none','FaceColor',rgb('DarkGreen'),'FaceAlpha',0.2);

% e(1) = shadedErrorBar1(tAxis,mean(tarp,2),2*std(tarp,[],2)/sqrt(sessionnb),'lineProps',rgb('Blue'));
% e(2) = shadedErrorBar1(tAxis,mean(refp,2),2*std(refp,[],2)/sqrt(sessionnb),'lineProps',rgb('DeepSkyBlue'));
% e(3) = shadedErrorBar1(tAxis,mean(tara,2),2*std(tara,[],2)/sqrt(sessionnb),'lineProps',rgb('Red'));
% e(4) = shadedErrorBar1(tAxis,mean(refa,2),2*std(refa,[],2)/sqrt(sessionnb),'lineProps',rgb('Coral'));

e1(1) = shadedErrorBar1(tAxis,mean(tarp,2),2*std(tarp,[],2)/sqrt(sessionnb),'lineProps',rgb('OrangeRed'));
e(1) = plot(tAxis,mean(tarp,2),'--','color',rgb('OrangeRed'),'LineWidth',2);
e1(2) = shadedErrorBar1(tAxis,mean(refp,2),2*std(refp,[],2)/sqrt(sessionnb),'lineProps',rgb('DeepPink'));
e(2) = plot(tAxis,mean(refp,2),'--','color',rgb('DeepPink'),'LineWidth',2);
e1(3) = shadedErrorBar1(tAxis,mean(tara,2),2*std(tara,[],2)/sqrt(sessionnb),'lineProps',rgb('OrangeRed'));
e(3) = plot(tAxis,mean(tara,2),'-','color',rgb('OrangeRed'),'LineWidth',2);
e1(4) = shadedErrorBar1(tAxis,mean(refa,2),2*std(refa,[],2)/sqrt(sessionnb),'lineProps',rgb('DeepPink'));
e(4) = plot(tAxis,mean(refa,2),'-','color',rgb('DeepPink'),'LineWidth',2);


plot([0,20],[0, 0],'-k','LineWidth',1)
plot([3,3],[-100, 100],'-.k','LineWidth',1)
plot([9,9],[-100, 100],'-.k','LineWidth',1)
  
lgd = legend([e],{' ', ' ',' ',' '},'Location','Northeast');
lgd.FontSize = 8;
legend('boxoff');

ax = gca;
ax.LineWidth = 1.5;
ylim([-0.4,0.4])
xlim([1,tAxis(end)]);

box(ax,'off')
%xlabel('Time (Sec)','FontName','Times New Roman','FontSize',18)
ylabel(' ','FontName','Times New Roman','FontSize',18)
%set(ax,'xtick',[1,3,9,13,18],'xtickLabel',{'-0.5','0','1.1','2.1','3.1'});
set(ax,'xtick',[1,3,9,13,18],'xtickLabel',{' ',' ',' ',' ',' '});

set(ax,'FontName','Times New Roman','FontSize',18);

% e = errorbar(mean(refa,2),2*std(refa,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'black'; e.CapSize = 15;
% p(1) = plot(mean(refa,2),'k','linewidth',2.5,'displayname','nogo active');
% e = errorbar(mean(refp,2),2*std(refp,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'black'; e.CapSize = 15;
% p(2) = plot(mean(refp,2),'k','linewidth',1,'displayname','nogo active');

% e = errorbar(mean(tara,2),2*std(tara,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'red'; e.CapSize = 15;
% p(3) = plot(mean(tara,2),'r','linewidth',2.5,'displayname','go active');
% e = errorbar(mean(tarp,2),2*std(tarp,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'red'; e.CapSize = 15;
% p(4) = plot(mean(tarp,2),'r','linewidth',1,'displayname','go passive');

% legend(p);  legend('show'); legend('boxoff');
% ylabel('projections on categorical axis')

% QUANTIFY SUPPRESSION OF NOGO SOUND UPON TASK ENGAGEMENT AND COMPARE WITH
% PROJECTION ON UNIT VECTOR
% actual data
enidx = (abs(tara)-abs(tarp));
supidx = (abs(refp)-abs(refa));
% unit vector
[All_Projections] = SaveAllProjections(Animal,'OnUV');

dp = All_Projections.passive;
%dp = dp(:,:,[1:14 16:end]);
da = All_Projections.active;
%da = da(:,:,[1:14 16:end]);

refa = squeeze(mean(da(:,1:3,:),2));
tara = squeeze(mean(da(:,4:6,:),2));
refp = squeeze(mean(dp(:,1:3,:),2));
tarp = squeeze(mean(dp(:,4:6,:),2));

unit_supidx = (abs(refp)-abs(refa));
h = ttest2(unit_supidx',supidx');

subplot(2,1,2); hold all; clear p;clear e;

area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[-100 100 -100 100],'LineStyle','none','FaceColor',rgb('DarkGreen'),'FaceAlpha',0.2);
area([tAxis(vec(1)) tAxis(vec(end)) tAxis(vec(end)) tAxis(vec(1))],[0 -100 0 -100],'LineStyle','none','FaceColor',rgb('DarkGreen'),'FaceAlpha',0.2);

e1(1) = shadedErrorBar1(tAxis,mean(supidx,2),2*std(supidx,[],2)/sqrt(sessionnb),'lineProps',Color_Prop{1});
e(1) = plot(tAxis,mean(supidx,2),'-','color',Color_Prop{1},'LineWidth',2);
e1(2) = shadedErrorBar1(tAxis,mean(unit_supidx,2),2*std(unit_supidx,[],2)/sqrt(sessionnb),'lineProps',Color_Prop{2});
e(2) = plot(tAxis,mean(unit_supidx,2),'-','color',Color_Prop{2},'LineWidth',2);

yl = get(gca,'ylim');
%plot(find(h),yl(2)*ones(1,sum(h)),'k','linewidth',3)


plot([0,20],[0, 0],'-k','LineWidth',1)
plot([3,3],[-100, 100],'-.k','LineWidth',1)
plot([9,9],[-100, 100],'-.k','LineWidth',1)


lgd = legend([e],{' ', ' '},'Location','Northeast');
lgd.FontSize = 8;
legend('boxoff');

ax = gca;
ax.LineWidth = 1.5;
ylim([-1,0.4])
xlim([1,tAxis(end)]);

box(ax,'off')
ylabel(' ','FontName','Times New Roman','FontSize',18)
set(ax,'xtick',[1,3,9,13,18],'xtickLabel',{' ',' ',' ',' ',' '});
set(ax,'FontName','Times New Roman','FontSize',18);



% e = errorbar(mean(supidx,2),2*std(supidx,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'black'; e.CapSize = 15;
% p(1) = plot(mean(supidx,2),'k','linewidth',2.5,'displayname','projection');
% e = errorbar(mean(unit_supidx,2),2*std(unit_supidx,[],2)/sqrt(sessionnb));
% e.Marker = '*'; e.MarkerSize = 10; e.Color = 'black'; e.CapSize = 15;
% p(2) = plot(mean(unit_supidx,2),'k','linewidth',1,'displayname','psth');

% yl = get(gca,'ylim');
% plot(find(h),yl(2)*ones(1,sum(h)),'k','linewidth',3)
% legend(p);  legend('show'); legend('boxoff');
% ylabel('NoGo suppression index')
   
end
function [All_Projections] = SaveAllProjections(Animal,which)
SavePathName = '/Users/rupesh/Dropbox/AC_Paper/OutlineDarft/Fig_2/Results/PopDecode/SessionWiseData/'; 
SavePath = [SavePathName(1:31) 'Comments1/Fig_2/Results/Projections/SessionWise/'];

if strcmp(which,'OnDecoder')
    Pass = load([SavePath(1:end-12)  Animal '_PassiveRandProj_Sessionwise.mat']);
    Act = load([SavePath(1:end-12)  Animal '_ActiveRandProj_Sessionwise.mat']);
elseif strcmp(which,'OnUV')
    Pass = load([SavePath(1:end-12)  Animal '_PassiveRandProj_Sessionwise_UV.mat']);
    Act = load([SavePath(1:end-12)  Animal '_ActiveRandProj_Sessionwise_UV.mat']);
end
 
All_Projections.passive = Pass.PassiveProj.stim{1};
 All_Projections.active = Act.ActiveProj.stim{1};

end