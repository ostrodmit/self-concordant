function [l,g] = sc_class(y,eta)
z = y.*eta;
r = sqrt(1 + z.^2);
zeta = z/r;
l = 2 + 1/(2 * log(2)) .* (-1 - z + r   +  log((r - 1)./(2*z.^2)));
g = -y ./ (2 * log(2)) .* (   - 1 + zeta + (z*zeta - 2*(r-1))./((r-1).*z.^2) );
end