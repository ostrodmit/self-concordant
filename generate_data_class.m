function [X,Y] = generate_data_class(d,n,theta,key,pNoise) % generate data for classification
X = randn(n,d);
Y = zeros(n,1);
for i = 1:n,
    x = X(i,:);
    eta = dot(x,theta);
    if strcmp(key,'0-1'),
        Y(i) = sign(eta);
    end
    if strcmp(key,'logistic'),
        p = 1/(1 + exp(-eta));
        r = rand;
        Y(i) = sign(p-r);
    end
    if nargin > 4, % additional noise with probability pNoise
        Y(i) = Y(i) * sign(rand-pNoise);
    end
end
end