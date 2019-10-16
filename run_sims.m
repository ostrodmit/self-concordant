d = 10;
theta_true = 5*randn(d,1)
n = 1000;
N = 100000;

%% Logistic data, classification
key = 'logistic';

%% Generate data
[XX,YY] = generate_data_class(d,N,theta,key); % population approximation
X = XX(1:n,:);
Y = YY(1:n);

%% Minimize empirical risk for logistic and SC losses
problem.options = optimoptions('fminunc','Algorithm','quasi-newton',...
    'SpecifyObjectiveGradient',true);
problem.x0 = 0.001 * randn(d,1);
problem.solver = 'fminunc';
%
f = @(theta)emp_risk(theta,X,Y,@logistic);
problem.objective = f;
[etheta_log,erisk_log,EXITFLAG,OUTPUT,egrad_log] = fminunc(problem);
% etheta_log
% emp_risk(theta_true,X,Y,@logistic)
% erisk_log
% norm(egrad_log)
% norm(etheta_log-theta_true)
%
f = @(theta)emp_risk(theta,X,Y,@sc_class);
problem.objective = f;
[etheta_sc,erisk_sc,EXITFLAG,OUTPUT,egrad_sc] = fminunc(problem);
% [etheta_sc,erisk_sc] = fminunc(problem);

% erisk_log 
% erisk_sc

%gscatter(X(:,1),X(:,2),Y(:));

ifPlotLosses = false;
if ifPlotLosses,
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