function z = scorescaling(s, per, clip)
% z = scorescaling(per, clip, s)
% Returns the goodness of fit for a given number of clipping pixels and
% sample period in pixels, where per is number of samples per symbol, not
% chip.

% params
nchip = 4;

if nargin < 3
  clip = 0;
end

term = [ones(1, per*nchip), zeros(1, per*nchip)];
testraw = [term, term, term];
test = testraw(clip+1:end);
n = length(test);

z = sum(abs(test - s(1:n)).^2)/n;
