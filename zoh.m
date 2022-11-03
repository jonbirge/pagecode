function xh = zoh(x, nh)
% xh = zoh(x, nh)

n = length(x);
xhmat = ones(nh, 1) * x(:).';
xh = reshape(xhmat, 1, nh*n);
