function xs = gentestbytes(n)

t = 0:(n-1);
xs = uint8(255*(-cos(2*pi*t/128)/2 + 0.5));
