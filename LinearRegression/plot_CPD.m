function plot_CPD(CPD,Color_Prop,L)
figure('units','inch','position',[0,0,6,4]);
taxis = 1:size(CPD,1);
sess = size(CPD,2);
for m = 1:size(CPD,3)
    H(m) = shadedErrorBar1(taxis,nanmean(CPD(:,:,m),2)',nanstd(CPD(:,:,m),[],2)'./sqrt(sess),'lineprop',Color_Prop{m});
    hold on;
end

% CPD Plot using MSE
    if size(CPD,1) == 18
        xticks = [1,3,9,14];
        yticks = [0,0.005,0.01];
    else
        xticks = [1,5.5,16.5,26.5];
    end
    ax = gca;
    ax.LineWidth = 1.5;
    set(ax,'FontSize',20,'FontName','Times New Roman');
    ylabel('CPD','FontSize',24);
    xlabel('Time bin','FontSize',24);
    xlim([taxis(1),taxis(end-1)]);
    %line([xticks(1),18],[0,0],'LineWidth',25,'color',rgb('DarkGray'))
    hold on;
    line([xticks(2),xticks(2)],[-100,100],'LineWidth',1.5,'color',rgb('Black'),'LineStyle','--')
    line([xticks(3),xticks(3)],[-100,100],'LineWidth',1.5,'color',rgb('Black'),'LineStyle','--')
    line([xticks(4),xticks(4)],[-100,0.0005],'LineWidth',1.5,'color',rgb('Black'),'LineStyle','--')
    ylim([0,0.01]);
    set(ax,'xtick',[xticks(2),xticks(3),xticks(4)],'xtickLabel',{'0','1.6','2.6'});
    %set(ax,'ytick',yticks,'ytickLabel',{'0','0.5','1.0'});
    [~, lgd,~] = legend([H.mainLine],L);
    %lgd = legend([H.mainLine],L);
    h1 = findobj(lgd,'type','line');
    set(h1,'LineWidth',2);
    ht = findobj(lgd,'type','text');
    set(ht,'Fontsize',14);
    %lgd.FontSize = 14;
    legend('boxoff')

end