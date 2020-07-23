function [] = plot_curves(fname) % plot excess risks
close all
clearvars -except fname
load(fname)
mean_excess_log = mean(excess_log,2);
mean_excess_sc = mean(excess_sc,2);
mean_excess_log4sc = mean(excess_log4sc,2);
dev_excess_log = 3*std(excess_log,1,2)/sqrt(T);
dev_excess_sc = 3*std(excess_sc,1,2)/sqrt(T);
dev_excess_log4sc = 3*std(excess_log4sc,1,2)/sqrt(T);
curves = boundedline(...
    log10(ss),mean_excess_log,dev_excess_log,'b',...
    log10(ss),mean_excess_sc,dev_excess_sc,'r',...
    log10(ss),mean_excess_log4sc,dev_excess_log4sc,'g',...
    'alpha');
axis tight;
legend('log','sc','log4sc')
end