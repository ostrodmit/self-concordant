function l = sc_robust(z)
r = sqrt(1 + 4*z.^2);
l = 0.5 * (r - 1 + log( (r - 1) ./ (2*z.^2) ) );
end
