d = 2;
theta = randn(d,1);
n = 100;

%% Logistic data, classification
key = 'logistic';
[X,Y] = generate_data_class(d,n,theta,key);
% gscatter(X(:,1),X(:,2),Y(:));
% Fit logistic loss

%% Plot losses
z = linspace(-5,5,50);
% plot sc_class vs. logistic
figure
[l1,g1] = sc_class(1,z);
[l2,g2] = logistic(1,z);
plot(z,l1,z,l2);
figure
plot(z,g2);
% plot sc_robust vs. logcosh vs. huber
figure
plot(z,sc_robust(abs(z)),z,huber(abs(z)),z,logcosh(z))