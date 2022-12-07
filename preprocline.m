function sout = preprocline(s, nsamp)
%PREPROCLINE Preprocess single barcode line
% Responsible for both taking out the DC term, as well as getting rid of
% the clock sync part.

% TODO: should eventually use a high-pass filter to remove DC term

% code parameters
nchip = 4;
nsync = 3;

% shift and normalize
smax = max(s);
smin = min(s);
skip = nsamp*nchip*nsync*2;
sout = s((1+skip):end) - (smax - smin)/2;

end
