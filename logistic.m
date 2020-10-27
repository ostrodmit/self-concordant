%% Logistic loss and its derivatives
function [l,g,h] = logistic(y,eta)
z = y*eta;
l = log(1+exp(-z))/log(2);
s = sigmoid(-z);
g = -y*s/log(2);
h = s*(1-s)/log(2);
end