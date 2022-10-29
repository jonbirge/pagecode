function z = scorescaling(per, clip, s)
% per is number of samples per symbol, not chip

% params
nchip = 4;

term = [ones(1, per*nchip), zeros(1, per*nchip)];
testraw = [term, term, term];
test = testraw(clip+1:end);
n = length(test);

z = sum(abs(test - s(1:n)).^2)/n;
