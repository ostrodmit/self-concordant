xKey = 'Gauss'; 
lg_n_min = 1; lg_n_max = 3; 
N = 1e4; 
R = 1;
dd = [8, 16, 32];
ddd = [64];
tic;
% yKey = 'logistic';
for yKey = ['ill-spec','probit']
    T = 400;
    for d = dd
        gauss=run_sims(R,d,lg_n_min,lg_n_max,N,T,xKey,yKey);
        plot_curves(xKey,yKey,gauss);
    end
    toc
    tic;
    T = 200;
    for d = ddd
        gauss=run_sims(R,d,lg_n_min,lg_n_max,N,T,xKey,yKey);
        plot_curves(xKey,yKey,gauss);
    end
end
toc