function [L,G,H] = emp_risk(theta,X,Y,loss)
n = length(Y);
l = zeros(n,1);
for i = 1:n, 
    y = Y(i);
    x = X(i,:);
    eta = dot(theta,x);
    z = y * eta;
    [l,g,h] = loss(y,eta);
    LL(i) = l;
    GG(i,:) = x.*g;
    HH(i,:,:) = (x * x') .* h;
end
L = sum(LL)/n;
G = sum(GG,1)./n;
H = sum(HH,1)./n;
end