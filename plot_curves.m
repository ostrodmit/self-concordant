function [] = plot_curves(xKey,yKey,fname) % plot excess risks
close all
clearvars -except xKey yKey fname
datapath = ['./data/' xKey '-' yKey '/'];
load([datapath fname '.mat'],'ss','T','excess_log','excess_sc','excess_log4sc')

excess_log(isinf(excess_log)) = NaN;
mean_excess_log = nanmean(excess_log,2);

excess_sc(isinf(excess_sc)) = NaN;
mean_excess_sc = nanmean(excess_sc,2);

excess_log4sc(isinf(excess_log4sc)) = NaN;
mean_excess_log4sc = mean(excess_log4sc,2);

dev_excess_log = 3*std(excess_log,1,2)/sqrt(T);
dev_excess_sc = 3*std(excess_sc,1,2)/sqrt(T);
dev_excess_log4sc = 3*std(excess_log4sc,1,2)/sqrt(T);
[curves,~] = boundedline(...
    log10(ss),mean_excess_log,dev_excess_log,'--b',...
    log10(ss),mean_excess_sc,dev_excess_sc,'-r',...
    log10(ss),mean_excess_log4sc,dev_excess_log4sc,'-.g',...
    'alpha');
for i = 1:3
    curves(i).LineWidth = 3;
end
% xt = xticks;
% xticklabels(strsplit(num2str(floor(10.^(xt)))));
treat_fig(curves,gca,gcf,xKey,yKey,fname);
end

function [] = treat_fig(curves,gca,gcf,xKey,yKey,fname)
%% Ticks, legend, etc. -- some magic settings
axis tight;
% xlim([2 4])
sfont = 6;
legend(curves,{'logistic' 'self-conc' 'calibrated'},'Location','southwest','interpreter','latex','FontSize',4*sfont);
xlabel('$\lg n$','interpreter','latex','fontsize',5*sfont); 
ylabel('$\lg$(excess risk)','interpreter','latex','fontsize',5*sfont); 
set(gca,'FontSize',4*sfont);
set(gca,'XMinorTick','on');
set(gca,'YMinorTick','on');
set(gca,'XMinorGrid','off');
set(gca,'YMinorGrid','off');
grid on
%% Printing
%set(gcf,'PaperPositionMode','Auto');
set(gcf,'defaulttextinterpreter','latex');
set(gcf, 'PaperSize', [11.69 8.27]); % paper size (A4), landscape
%savefig(gcf,[fname '.fig']);
% Extend the plot to fill entire paper.
set(gcf, 'PaperPosition', [0 0 11.69 8.27]);
figspath = ['./figs/' xKey '-' yKey '/'];
if ~exist(figspath, 'dir')
  mkdir(figspath);
end
% print('-dpdf',[figspath fname '.pdf'],'-r0','-painters');
% print('-depsc',[figspath fname '.eps'],'-painters');
% if exist(statfile, 'file')==2, delete(statfile); end
saveas(gcf,[figspath fname '.fig'],'fig');
saveas(gcf,[figspath fname '-preview.pdf'],'pdf');

% % Save to Dropbox as well
% saveas(gcf,['~/Dropbox/self-concordant/EJS/v1/figs/' xKey '-' yKey '/' fname '.fig'],'fig');
% saveas(gcf,['~/Dropbox/self-concordant/EJS/v1/figs/' xKey '-' yKey '/' fname '-preview.pdf'],'pdf');
%
% saveas(gcf,[figspath fname '.pdf'],'pdf','-fillpage');
end