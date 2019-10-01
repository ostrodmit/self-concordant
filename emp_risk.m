function [R.G] = emp_risk(theta,X,Y,loss,ifClass)
n = length(Y);
l = zeros(n,1);
for i = 1:n, 
    y = Y(i);
    x = X(i,:);
    eta = dot(theta,x);
    if ifClass, % classification
        l(i) = loss((2*y-1)*eta);
    else % regression
        l(i) = loss(eta-y);
        g(i) = 
    end
end
end