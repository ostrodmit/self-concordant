function [fname] = run_sims(d,n,N,T,xKey,yKey)
clearvars -except d n N T xKey yKey
rng(0,'twister'); % initialize random number generator
wb = waitbar(0,'Processing...','WindowStyle','modal');

%% Boundedline functions
addpath('boundedline-pkg/boundedline');
addpath('boundedline-pkg/singlepatch');
addpath('boundedline-pkg/catuneven');
addpath('boundedline-pkg/Inpaint_nans');

% d = 10;
% n = 100;
% N = 10000;
% T = 10;

% R = sqrt(d);
R = 12;

theta_true = R * ones(d,1) / sqrt(d);
%% Logistic data, classification
% xKey = 'Gaussian';
% yKey = 'logistic';

%% Generate population
[XX,YY] = generate_data_class(d,N,theta_true,xKey,yKey);
 
%% Minimize empirical risk for logistic and SC losses
options = optimoptions('fminunc');
options.OptimalityTolerance = 1e-8;  
options.Algorithm = 'quasi-newton';
options.Display = 'notify-detailed';
options.SpecifyObjectiveGradient = true;
x0 = ones(d,1);
%
pop_log = @(theta)emp_risk(theta,XX,YY,@logistic);
pop_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);


[ptheta_log,prisk_log,~,~,pgrad_log] = fminunc(pop_log,x0,options);
[ptheta_sc,prisk_sc,~,~,egrad_sc] = fminunc(pop_sc,x0,options);

% sample sizes
ss = ceil(logspace(log10(n),log10(N),20));

for k = 1:length(ss)
    % Sample size
    m = ss(k);
    % For T trials:
    for t = 1:T
    % Generate sample
        [X,Y] = generate_data_class(d,m,theta_true,xKey,yKey);
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

%% Save results in a file
respath = ['./data/' xKey '-' yKey '/'];
if ~exist(respath, 'dir'),
  mkdir(respath);
end
addpath(respath);
fname = [respath 'd-' num2str(d) '_N-' num2str(N) '_T-' num2str(T) '.mat'];
% if exist(statfile, 'file')==2, delete(statfile); end
save(fname,'ss','T','excess_log','excess_sc','excess_log4sc','-v7.3');