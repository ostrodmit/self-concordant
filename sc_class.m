%% SC classification loss and its derivatives
function [l,g,h] = sc_class(y,eta)
z = y*eta;
r = sqrt(1+z^2);
if z ~= 0
    l = 2 + 1/log(4) * (-1-z + r + log((r-1)/(2*z^2)));
    g = y*(r-z-1)/z/log(4); % verified through partial differences
    h = (1-1/r)/z^2/log(4);
else
    l = 1;
    g = -y/log(4);
    h = 1/4/log(2);
end
end