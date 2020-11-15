xKey = 'Gauss'; 
lg_n_min = 1; lg_n_max = 3; 
N = 1e4; 
R = 1;
dd = [8, 16, 32];
ddd = [64];
% yKey = ;
for yKey = {'logistic','probit'}
    tic;
    T = 400;
    for d = dd
        gauss=run_sims(R,d,lg_n_min,lg_n_max,N,T,xKey,yKey{1});
        plot_curves(xKey,yKey{1},gauss);
    end
    toc
    tic;
    T = 200;
    for d = ddd
        gauss=run_sims(R,d,lg_n_min,lg_n_max,N,T,xKey,yKey{1});
        plot_curves(xKey,yKey{1},gauss);
    end
    toc
end