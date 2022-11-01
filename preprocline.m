function [sout, nsamp] = preprocline(sin)
%PREPROCLINE Preprocess single barcode line

% params
nchip = 4;

zs = [];
clips = 0:32;
scales = 2:24;
params = cell(length(clips), length(scales));
for kc = 1:length(clips)
  for ks = 1:length(scales)
    zs(kc, ks) = scorescaling(scales(ks), clips(kc), sin); %#ok<AGROW> 
    params{kc, ks} = [clips(kc) scales(ks)];
  end
end

[~, kmin] = min(zs, [], 'all', 'linear');
p = params{kmin};
startk = nchip*2*3*p(2) - p(1) + 1;
sout = sin(startk:end);  % signal with fiducials removed
nsamp = p(2);  % spatial samples per symbol

sout = sout - mean(sout);  % should eventually use a high-pass filter to remove DC term

end