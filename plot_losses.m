%% Plot losses
M = 10001;
zz = linspace(-5,5,M);
l1 = zeros(M,1); l2 = zeros(M,1); 
g1 = zeros(M,1); g2 = zeros(M,1);
h1 = zeros(M,1); h2 = zeros(M,1);
zIdx = 0;
for z = zz, 
    zIdx = zIdx + 1;
    [l1(zIdx),g1(zIdx),h1(zIdx)] = logistic(1,z);
    [l2(zIdx),g2(zIdx),h2(zIdx)] = sc_class(1,z);
end
% plot sc_class vs. logistic
figure
plot(zz,l1,zz,l2);
title('Loss')
legend('logistic','SC')
figure
plot(zz,g1,zz,g2);
title('1st derivative')
legend('logistic','SC')
figure
plot(zz,h1,zz,h2);
title('2nd derivative')
legend('logistic','SC')
% plot sc_robust vs. logcosh vs. huber
% figure
% plot(z,sc_robust(abs(z)),z,huber(abs(z)),z,logcosh(z))