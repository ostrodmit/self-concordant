function l = huber(z)
l = (z <= 1) .* (z.^2/2) + (z > 1) .* (z - 1/2);
end