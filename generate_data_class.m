function [X,Y] = generate_data_class(d,n,theta,xKey,yKey,pNoise) % generate data for classification
if strcmp(xKey,'Gaussian'),
    X = randn(n,d); % Gaussian design
end
if strcmp(xKey,'Rademacher'),
    X = sign(randn(n,d)) + 0.1*randn(n,d); % quasi-Rademacher design
end
if strcmp(xKey,'Hazan'),
    R = norm(theta);
    q = min(1/R * exp(-R),1);
    x_c = [0,-1,zeros(1,d-2)]./R;
    x_l = [-1,1,zeros(1,d-2)]./sqrt(2);
    x_r = [1,1,zeros(1,d-2)]./sqrt(2);
    for i = 1:n,
        if rand < (1-q),
            X(i,:) = x_c;
        else
            if rand < 1/2,
                X(i,:) = x_l;
            else
                X(i,:) = x_r;
            end
        end
    end
end
% X = 2*(rand(n,d)-0.5); % Uniform on the unit cube
Y = zeros(n,1);
for i = 1:n,
    x = X(i,:);
    eta = dot(x,theta);
    if strcmp(yKey,'0-1'),
        Y(i) = sign(eta);
    end
    if strcmp(yKey,'logistic'),
        p = 1/(1 + exp(-eta));
        r = rand;
        Y(i) = sign(p-r);
    end
    if strcmp(yKey,'ones'),
        Y(i) = 1;
    end
    if nargin > 5 && pNoise > 0, % additional noise with probability pNoise
        Y(i) = Y(i) * sign(rand-pNoise);
    end
end
end
