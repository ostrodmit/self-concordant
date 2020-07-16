clear all
d = 10;
theta_true = ones(d,1);
n = 100;
N = 1000;

%% Logistic data, classification
key = 'logistic';

%% Generate data
[XX,YY] = generate_data_class(d,N,theta_true,key); % population approximation
 
%% Minimize empirical risk for logistic and SC losses
options = optimoptions('fminunc');
options.OptimalityTolerance = 1e-8;  
options.Algorithm = 'quasi-newton';
options.SpecifyObjectiveGradient = true;
x0 = 0.001 * randn(d,1);
%
pop_log = @(theta)emp_risk(theta,XX,YY,@logistic);
pop_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);

[ptheta_log,prisk_log,~,~,pgrad_log] = fminunc(pop_log,x0,options);
[ptheta_sc,prisk_sc,~,~,egrad_sc] = fminunc(pop_sc,x0,options);

% sample sizes
ss = ceil(logspace(1,2.5,5))

for k = 1:length(ss)
    m = ss(k)
    strcat(int2str(k),'/',int2str(length(ss)))
    Xm = XX(1:m,:);
    Ym = YY(1:m,:);
    emp_log = @(theta)emp_risk(theta,Xm,Ym,@logistic);
    emp_sc = @(theta)emp_risk(theta,Xm,Ym,@sc_class);
    [etheta_log,erisk_log,~,~,egrad_log] = fminunc(emp_log,x0,options);
    [etheta_sc,erisk_sc,~,~,pgrad_sc] = fminunc(emp_sc,x0,options);
    excess_log(k) =  pop_log(etheta_log)-pop_log(ptheta_log);
    excess_sc(k) = pop_sc(etheta_sc)-pop_sc(ptheta_sc);
    excess_log4sc(k) = pop_log(etheta_sc)-pop_log(ptheta_log);
end


%print('Excess risk for logistc loss')
%pop_log(etheta_log)-pop_log(ptheta_log)
%print('Excess risk for SC loss')
%pop_sc(etheta_sc)-pop_sc(ptheta_sc)
%norm(theta_true-ptheta_log)
%norm(theta_true-ptheta_sc)

% etheta_log
% emp_risk(theta_true,X,Y,@logistic)
% erisk_log
% norm(egrad_log)
% norm(etheta_log-theta_true)
%
% [etheta_sc,erisk_sc] = fminunc(problem);

% erisk_log 
% erisk_sc

%gscatter(X(:,1),X(:,2),Y(:));

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

length(ss)
length(excess_log)

close all
loglog(ss,excess_log,'r')
%plot(ss,excess_log,'r',ss,excess_sc,'b',ss,excess_log4sc,'g')
%legend('log','sc','log4sc')

