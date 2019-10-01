function [X,Y] = generate_data_class(d,n,theta,key) % generate data for classification
X = randn(n,d);
Y = zeros(n,1);
for i = 1:n,
    x = X(i,:);
    eta = dot(x,theta);
    if strcmp(key,'0-1'),
        Y(i) = sign(eta);
    end
    if strcmp(key,'logistic'),
        p = exp(eta)/(1 + exp(eta));
        r = rand;
        Y(i) = sign(r-p);
    end
end
end