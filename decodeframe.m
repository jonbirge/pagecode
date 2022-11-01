function [xs, nsamp] = decodeframe(sraw)

% determine "clock" and offset
[s, nsamp] = preprocline(sraw);

xvec0 = [-1 1 -1 1];
xvec1 = [1 -1 1 -1];
xvec2 = [-1 -1 1 1];
xvec3 = [1 1 -1 -1];
xvect1 = [1 1 1 1];
xvect2 = [-1 -1 -1 -1];

% construct decode matrix
% build filled out code matrix including onerse sample buff in
% the order: (1-left-shift; 1-no-shift; 1-right-shift; ...)
dc = [xvec0; xvec1; xvec2; xvec3];
[ncode, nchip] = size(dc);
decmat = zeros(ncode + 1, nchip*nsamp+2);
for k = 1:ncode  
  scode = zoh(dc(k,:), nsamp);
  decmat(k,:) = [scode 0 0];
  decmat(k+ncode,:) = [0 scode 0];
  decmat(k+2*ncode,:) = [0 0 scode];
end
decmat(end+1:end+2,:) = [0 zoh(xvect1, nsamp) 0; 0 zoh(xvect2, nsamp) 0];

% construct code matrix (what it all means)
% [code, sample offset]
codmat = ...
  [0 -1; 1 -1; 2 -1; 3 -1; ...
  0 0; 1 0; 2 0; 3 0; ...
  0 1; 1 1; 2 1; 3 1;
  4 0; 5 0];

% go through and pull out windows for decoding single chips. another
% approach to try is convolving each code with the entire signal, and then
% going back and figuring out each maximum likelihood detection afterwards.
% not as easy, probably, but much more computationally efficient. no
% premature optimization, though...
% termsig = false;
ns = length(s);
nchipest = floor(ns/nchip/nsamp);
xchipraw = uint8(zeros(1, nchipest));  % 2-bit chip decode buffer
ks = 1;  % index into signal vector
kx = 1;  % index into decoded chip vector
stride = nchip*nsamp + 1;
while ((ks+stride) < ns)
  schip = s(ks:(ks+stride));  % get signal with buffer
  dec = decmat*schip(:);
  [~, kmax] = max(dec);
  maxlik = codmat(kmax,:);
  xchipraw(kx) = maxlik(1);
  shim = double(maxlik(2));  % scan adjustment, should eventually use PLL
  ks = ks + nsamp*nchip + shim;  % advance decode window
  kx = kx + 1;
end

xchips = xchipraw(xchipraw < 4);
xs = uint8(zeros(1, floor(length(xchips)/nchip)));  % should check if div by nchip
for kd = 1:length(xs)
  kchip = nchip*(kd-1) + 1;
  xchip = xchips(kchip:(kchip+nchip-1));
  x = 2^6*xchip(1) + 2^4*xchip(2) + 2^2*xchip(3) + xchip(4);
  xs(kd) = x;
end
