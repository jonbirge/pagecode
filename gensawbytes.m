function xs = gensawbytes(n)

up = true;
x = 0;
xs = zeros(1, n);
for k = 1:n
  xs(k) = x;
  if up
    x = x + 1;
  else
    x = x - 1;
  end
  if up
    if x > 254
      up = false;
    end
  else
    if x < 1
      up = true;
    end
  end
end
