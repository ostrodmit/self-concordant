clearvars
rng(0,'twister'); % initialize random number generator
wb = waitbar(0,'Processing...','WindowStyle','modal');

%% Boundedline functions
addpath('boundedline-pkg/boundedline');
addpath('boundedline-pkg/singlepatch');
addpath('boundedline-pkg/catuneven');
addpath('boundedline-pkg/Inpaint_nans');

d = 10;
theta_true = ones(d,1);
n = 100;
N = 10000;
T = 10;
%% Logistic data, classification
key = 'logistic';

%% Generate population
[XX,YY] = generate_data_class(d,N,theta_true,key);
 
%% Minimize empirical risk for logistic and SC losses
options = optimoptions('fminunc');
options.OptimalityTolerance = 1e-8;  
options.Algorithm = 'quasi-newton';
options.Display = 'none';
options.SpecifyObjectiveGradient = true;
x0 = ones(d,1);
%
pop_log = @(theta)emp_risk(theta,XX,YY,@logistic);
pop_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);

[ptheta_log,prisk_log,~,~,pgrad_log] = fminunc(pop_log,x0,options);
[ptheta_sc,prisk_sc,~,~,egrad_sc] = fminunc(pop_sc,x0,options);

% sample sizes
ss = ceil(logspace(log10(n),log10(N/2),20));

for k = 1:length(ss)
    % Sample size
    m = ss(k);
    % For T trials:
    for t = 1:T
    % Generate sample
        [X,Y] = generate_data_class(d,m,theta_true,key);
        emp_log = @(theta)emp_risk(theta,X,Y,@logistic);
        emp_sc = @(theta)emp_risk(theta,X,Y,@sc_class);
        [etheta_log,erisk_log,~,~,egrad_log] = fminunc(emp_log,x0,options);
        [etheta_sc,erisk_sc,~,~,pgrad_sc] = fminunc(emp_sc,x0,options);
        excess_log(k,t) =  log10(pop_log(etheta_log)-pop_log(ptheta_log));
        excess_sc(k,t) = log10(pop_sc(etheta_sc) - pop_sc(ptheta_sc));
        excess_log4sc(k,t) = log10(pop_log(etheta_sc) - pop_log(ptheta_log));
    end
    %% Compute means and stdev
    waitbar(k/length(ss))
end
close(wb)
mean_excess_log = mean(excess_log,2);
mean_excess_sc = mean(excess_sc,2);
mean_excess_log4sc = mean(excess_log4sc,2);
dev_excess_log = std(excess_log,1,2)/sqrt(T);
dev_excess_sc = std(excess_sc,1,2)/sqrt(T);
dev_excess_log4sc = std(excess_log4sc,1,2)/sqrt(T);

ifPlotLosses = 0;
if ifPlotLosses
    %% Plot losses
    z = linspace(-5,5,50);
    % plot sc_class vs. logistic
    figure
    [l1,g1,h1] = sc_class(1,z);
    [l2,g2,h2] = logistic(1,z);
    plot(z,l1,z,l2);
    figure
    plot(z,g1,z,g2);
    figure
    plot(z,h1,z,h2);
    % plot sc_robust vs. logcosh vs. huber
    % figure
    % plot(z,sc_robust(abs(z)),z,huber(abs(z)),z,logcosh(z))
end

% Plot excess risks
close all
%loglog(ss,excess_log,'r')
%loglog(ss,mean_excess_log,'r',ss,mean_excess_sc,'b',ss,mean_excess_log4sc,'g')
ssizes = log10(1:length(ss));
curves = boundedline(...
    log10(ss),mean_excess_log,dev_excess_log,'r',...
    log10(ss),mean_excess_sc,dev_excess_sc,'b',...
    log10(ss),mean_excess_log4sc,dev_excess_log4sc,'g',...
    'alpha');
axis tight;
legend('log','sc','log4sc')