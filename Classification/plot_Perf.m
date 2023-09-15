function plot_Perf(CC1,CC2,CC3,Ccode)
Perf{1} = CC1;
Perf{2} = CC2;
Perf{3} = CC3;
Nb = size(Perf{1},1);
%Legend_labels = {'Passive','Active-Correct','Random Shuffling'};
Legend_labels = {'Passive ',' Active-Correct ','Shuffling Labels ',' '};
x_axis = linspace(-0.5,3.1,size(Perf{1},2));
figure('units','inch','position',[0,0,7,4]);
for i = 1:size(Perf,2)
    H(i) = shadedErrorBar1(x_axis,nanmean(Perf{i},1), nanstd(Perf{i},1)/sqrt(Nb),'lineprops',Ccode{i});
    hold on;
end
YMAX = 1.0;
binsize = 0.1;
Y_min = 0.4;
xlim([-0.5 3.1])
ylim([0.45 0.7]);
line([-0.5,0],[Y_min+0.015-0.1,Y_min+0.015-0.1],'LineWidth',25,'Color',[0.6,0.6,0.6])
line([0,1.1],[Y_min+0.015-0.1,Y_min+0.015-0.1],'LineWidth',25,'Color',[0.6,0.6,0.6])
line([1.1,2.1],[Y_min+0.015-0.1,Y_min+0.015-0.1],'LineWidth',25,'Color',[0.6,0.6,0.6]);
line([2.1,3.1],[Y_min+0.015-0.1,Y_min+0.015-0.1],'LineWidth',25,'Color',[0.6,0.6,0.6]);
line([0-binsize,0-binsize],[Y_min-0.1,YMAX-0.1],'LineWidth',1, 'LineStyle','--','Color','k')
line([1.1-binsize,1.1-binsize],[Y_min-0.1,YMAX-0.1],'LineWidth',1, 'LineStyle','--','Color','k')
line([2.1-binsize,2.1-binsize],[Y_min-0.1,YMAX-0.1],'LineWidth',1, 'LineStyle','--','Color','k')
line([3.1-binsize,3.1-binsize],[Y_min-0.1,YMAX-0.1],'LineWidth',1, 'LineStyle','--','Color','k')
ax = gca;
ax.LineWidth = 1.5;
set(ax,'FontSize',20);
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [10 6]);
set(ax,'TickLength',[0.02,0.002]);
set(gca,'box','on','LineWidth',1.2,'FontName','Times New Roman','FontSize',20)
xlabel('Time (Sec)','FontName','Times New Roman','FontSize',22)
ylabel('Performance','FontName','Times New Roman','FontSize',22)
lgd = legend([H.mainLine],Legend_labels,'Location', 'Northwest','FontSize',14);
lgd.FontSize = 16;
box off;
legend('boxoff')
end