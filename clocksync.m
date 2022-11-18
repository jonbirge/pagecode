function nsamp = clocksync(s)
% nsamp = clocksync(s)
% Returns the estimated number of pixels per symbol in the signal,
% currently assumed to be an integer.

scales = 2:24;
zs = length(scales);
for ks = 1:length(scales)
  zs(ks) = scorescaling(s, scales(ks));
end

[~, kmin] = min(zs);
nsamp = scales(kmin);  % spatial samples per symbol
