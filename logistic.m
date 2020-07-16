%% Logistic loss and its derivatives
function [l,g,h] = logistic(y,eta)
z = y*eta;
s = sigmoid(-z);
%l = -log(1-s);
l = - z + abs(z) + log( exp(-z-abs(z)) + exp(z-abs(z)) );
g = -2*y*s;
h = 4*s*(1-s);
end

function s = sigmoid(t)
s = exp(t-abs(t)) / (exp(t-abs(t)) + exp(-t-abs(t)));
end