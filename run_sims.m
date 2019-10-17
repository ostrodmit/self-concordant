d = 10;
theta_true = randn(d,1);
nn = uint16(logspace(1,3.5,40));
N = 10000;

%% Logistic data, classification
key = 'logistic';

%% Generate population distribution
[XX,YY] = generate_data_class(d,N,theta_true,key); 
prisk_log = @(theta)emp_risk(theta,XX,YY,@logistic);
prisk_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);

problem.x0 = 0.001 * randn(d,1);

%% Minimize population risk
% logistic 
problem.x0 = theta_true + 0.0001*ones(d,1); % ??? warm-start from the true parameter value
problem.objective = prisk_log;
[ptheta_log,prisk_opt_log,EXITFLAG,OUTPUT,pgrad_log] = fminunc(problem);
% SC loss
problem.objective = prisk_sc;
[ptheta_sc,prisk_opt_sc,EXITFLAG,OUTPUT,pgrad_sc] = fminunc(problem);

%% ERM fitting
excess_log = zeros(size(nn));
excess_sc = zeros(size(nn));
excess_apx = zeros(size(nn));
nIdx = 0;
for n = nn,
    nIdx = nIdx + 1;
    %% Generate training sample
    [X,Y] = generate_data_class(d,n,theta_true,key);
    %gscatter(X(:,1),X(:,2),Y(:));
    erisk_log = @(theta)emp_risk(theta,X,Y,@logistic);
    erisk_sc = @(theta)emp_risk(theta,X,Y,@sc_class);

    %% Minimize empirical risk for logistic and SC losses
    problem.options = optimoptions('fminunc','Algorithm','trust-region',...
        'SpecifyObjectiveGradient',true);
    problem.solver = 'fminunc';
    %
    problem.objective = erisk_log;
    [etheta_log,erisk_opt_log,EXITFLAG,OUTPUT,egrad_log] = fminunc(problem);
    %
    problem.objective = erisk_sc;
    [etheta_sc,erisk_opt_sc,EXITFLAG,OUTPUT,egrad_sc] = fminunc(problem);
    
    %% Compute excess risks
    % excess_log = prisk_log(etheta_log) - prisk_log(theta_true) % logistic loss
    excess_log(nIdx) = prisk_log(etheta_log) - prisk_log(ptheta_log); % logistic loss
    excess_sc(nIdx) = prisk_sc(etheta_sc) - prisk_sc(ptheta_sc); % SC loss
    excess_apx(nIdx) = prisk_log(etheta_sc) - prisk_log(ptheta_log); % ``approximated'' risk
end

%% Plot excess risks
nn_double = double(nn);
plot(log10(nn_double),log(excess_log),log10(nn_double),log(excess_sc),log10(nn_double),log(excess_apx));
legend('logistic','SC','transfer');
xlabel('log(n)');
ylabel('log(excess_risk)');