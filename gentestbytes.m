function xs = gentestbytes(n)

t = linspace(0, 8*pi, n);
xs = uint8(255*(-cos(t)/2 + 0.5));
