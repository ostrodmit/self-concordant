%% Logistic loss and its derivatives
function [l,g,h] = logistic(y,eta)
z = y*eta;
% l = log(1 + exp(-2*z));
s = sigmoid(-2*z);
l = -log(1-s);
g = -2*y*s;
h = 4*s*(1-s);
end

function s = sigmoid(t)
tplus = max(t,0);
s = exp(t-tplus) / (exp(t-tplus) + exp(-tplus));
end