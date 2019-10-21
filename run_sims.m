tic;
d = 2;
R = 5.0;
nn = uint16(logspace(2,4,31));
N = 100000; % population size
T_prior = 10;
T_post = 20; % number of trials

wb = waitbar(0,'Progress');

%% Population distribution parameters
% xKey = 'Gaussian'; % Gaussian design
% xKey = 'Rademacher'; % Rademacher design
xKey = 'Hazan'; % adversarial distribution due to Hazan et al. (2014)
pNoise = 0.0; % add label noise
% yKey = '0-1'; % 0-1 labels
% yKey = 'logistic'; % logistic labels
yKey = 'ones';

for t_prior = 1:T_prior,
    %% Generate population distribution
    theta_true = R * randn(d,1)./sqrt(d);
    [XX,YY] = generate_data_class(d,N,theta_true,xKey,yKey,pNoise); 
    prisk_log = @(theta)emp_risk(theta,XX,YY,@logistic);
    prisk_sc = @(theta)emp_risk(theta,XX,YY,@sc_class);

    % figure
    % gscatter(XX(1:200,1),XX(1:200,2),YY(1:200))

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
    excess_log = zeros(T_prior,T_post,length(nn));
    excess_sc = zeros(T_prior,T_post,length(nn));
    excess_apx = zeros(T_prior,T_post,length(nn));
    problem.x0 = zeros(d,1) + 0.01 * randn(d,1);
    nIdx = 0;
    for n = nn,
        nIdx = nIdx + 1;
        waitbar((t_prior-1)*length(nn)+nIdx./(T_prior * length(nn)),wb);
        for t_post = 1:T_post,
            %% Generate training sample
            %
            [X,Y] = generate_data_class(d,n,theta_true,xKey,yKey,pNoise);
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
            excess_log(t_prior,t_post,nIdx) = prisk_log(etheta_log) - prisk_log(ptheta_log); % logistic loss
            excess_sc(t_prior,t_post,nIdx) = prisk_sc(etheta_sc) - prisk_sc(ptheta_sc); % SC loss
            %     excess_apx(nIdx) = prisk_log(etheta_sc) - prisk_log(ptheta_log); % ``approximated'' risk
        end
    end
end
%% Excess risks averaged over T experiments
T = T_prior * T_post;
ave_excess_log = squeeze(sum(sum(excess_log,1)))./T;
ave_excess_sc = squeeze(sum(sum(excess_sc,1)))./T;
%% Plot them
nn_double = double(nn);
figure
plot(log10(nn_double),log10(ave_excess_log),log10(nn_double),log10(ave_excess_sc));%,log10(nn_double),log(excess_apx));
legend('logistic','SC');%,'transfer');
xlabel('log(n)');
ylabel('log(excessRisk)');
close(wb)
toc