xKey = 'Hazan'; yKey = 'always-1';
d = 3; 
lg_n_min = 1; lg_n_max = 4; 
N = 5e4; 
T = 1600;
RR = linspace(1,7,4);
tic;
for R = RR
    hazan=run_sims(R,d,lg_n_min,lg_n_max,N,T,xKey,yKey);
    plot_curves(xKey,yKey,hazan);
end
toc