d = 10;
R = 1.0;
nn = uint16(logspace(1,3.5,30));
N = 10000; % population size
T = 10; % number of trials

%% Generate population distribution
% key = '0-1';
key = 'logistic';
pNoise = 0; % add classification noise
theta_true = R * ones(d,1);
[XX,YY] = generate_data_class(d,N,theta_true,key,pNoise); 
prisk_log = @(theta)emp_risk(theta,XX,YY,@logistic);
prisk_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);

gscatter(XX(1:200,1),XX(1:200,2),YY(1:200));

%% Minimize population risk
% logistic 
problem.options = optimoptions('fminunc','Algorithm','quasi-newton',...
        'SpecifyObjectiveGradient',true,'CheckGradients',false,...
        'Display','notify-detailed');%'PlotFcn','optimplotfval');
problem.solver = 'fminunc';
% % Box constraints for ill-conditioned case (n <= d)
% problem.A = [eye(d);-eye(d)]; 
% problem.b = 1e6*ones(2*d,1);
problem.x0 = theta_true + 0.0001*ones(d,1); % warm-start from the true parameter value
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
    for t = 1:T,
        %% Generate training sample
        %
        [X,Y] = generate_data_class(d,n,theta_true,key,pNoise);
        erisk_log = @(theta)emp_risk(theta,X,Y,@logistic);
        erisk_sc = @(theta)emp_risk(theta,X,Y,@sc_class);
        
        %% Minimize empirical risk for logistic and SC losses
        problem.x_0 = zeros(d,1);
        %
        problem.objective = erisk_log;
        [etheta_log,erisk_opt_log,EXITFLAG,OUTPUT,egrad_log] = fminunc(problem);
        %
        problem.objective = erisk_sc;
        [etheta_sc,erisk_opt_sc,EXITFLAG,OUTPUT,egrad_sc] = fminunc(problem);

        %% Compute excess risks
        excess_log(t,nIdx) = prisk_log(etheta_log) - prisk_log(ptheta_log); % logistic loss
        excess_sc(t,nIdx) = prisk_sc(etheta_sc) - prisk_sc(ptheta_sc); % SC loss
        %     excess_apx(nIdx) = prisk_log(etheta_sc) - prisk_log(ptheta_log); % ``approximated'' risk
    end
end
ave_excess_log = sum(excess_log,1)/T;
ave_excess_sc = sum(excess_sc,1)/T;

%% Plot excess risks averaged over T experiments
nn_double = double(nn);
plot(log10(nn_double),log10(ave_excess_log),log10(nn_double),log10(ave_excess_sc));%,log10(nn_double),log(excess_apx));
legend('logistic','SC');%,'transfer');
xlabel('log(n)');
ylabel('log(excessRisk)');