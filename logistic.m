function [l,g] = logistic(y,eta)
z = y.*eta;
l = log(1 + exp(-z));
s = sigmoid(-z);
g = -y.*s;
h = s.*(1-s);
end

function s = sigmoid(t)
s = exp(t) ./ (exp(t) + 1);
end