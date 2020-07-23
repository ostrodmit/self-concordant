%% Plot losses
z = linspace(-5,5,50);
% plot logistic vs. sc_class
for i = 1:length(z)
    [l1(i),g1(i),h1(i)] = logistic(1,z(i));
    [l2(i),g2(i),h2(i)] = sc_class(1,z(i));
end
%%
figure
plot(z,l1,z,l2);
legend('logistic','SC')
%%
figure
plot(z,g1,z,g2);
legend('logistic','SC')
%%
figure
plot(z,h1,z,h2);
legend('logistic','SC')
% plot sc_robust vs. logcosh vs. huber
% figure
% plot(z,sc_robust(abs(z)),z,huber(abs(z)),z,logcosh(z))