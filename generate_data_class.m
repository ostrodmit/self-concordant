function [X,Y] = generate_data_class(d,n,theta,xKey,yKey) % generate data for classification
if strcmp(xKey,'Gauss')
    X = randn(n,d); % Gaussian design
end
if strcmp(xKey,'Rademacher')
    X = sign(randn(n,d)); %+ 0.1*randn(n,d); % quasi-Rademacher design
end
if strcmp(xKey,'Hazan')
    R = norm(theta);
    %q = min(1/R * exp(-R),1);
    r = max(R/sqrt(2)*(1+exp(0.9))/(1+exp(-0.9*R/sqrt(2))),1); % Hazan's p/(1-p)
    p = r/(r+1);
    x_c = [0,-1,zeros(1,d-2)]./R;
    x_l = [-1,1,zeros(1,d-2)]./sqrt(2);
    x_r = [1,1,zeros(1,d-2)]./sqrt(2);
    for i = 1:n
        if rand < p
          X(i,:) = x_c;
        else
            eps = 0.25;
            rSign = 2*(rand>.5) - 1;
            if rand < 1/2+eps *rSign
                X(i,:) = x_l;
            else
                X(i,:) = x_r;
            end
        end
    end
end
Y = zeros(n,1);
for i = 1:n
    x = X(i,:);
    eta = dot(x,theta);
    if strcmp(yKey,'always-1')
        Y(i) = 1;
    end
    if strcmp(yKey,'0-1')
        Y(i) = sign(eta);
    end
    if strcmp(yKey,'logistic')
        prob = 1/(1 + exp(-eta));
        r = rand;
        Y(i) = sign(prob-r);
    end
    if strcmp(yKey,'probit')
        prob = normcdf(eta);
        r = rand;
        Y(i) = sign(prob-r);
    end
    if strcmp(yKey,'ill-spec')
        %prob = 1/(1 + exp(-eta * exp(-eta^2/2)));
        prob = 1/(1 + exp(-eta * cos(eta)));
        r = rand;
        Y(i) = sign(prob-r);
    end
end
end