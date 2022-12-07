function im = simpage(spage, linesnr, hbuf, wbuf)
% im = simpage(spage, hbuf, vbuf)
%
% Simulate page print and scan, returning binary sampled image from array
% spage, with relative margins expressed by hbuf and vbuf.

% parameters
nk = 4;  % samples per symbol in both axes
clip = randi(2) - 1;  % number of samples to clip on each end
jitt = 0.1;

% init
[nh, nw] = size(spage);
nhbuff = nk*floor(nh*hbuf/2);
nwbuff = nk*floor(nw*wbuf/2);
nhim = nhbuff + nk*nh + nhbuff;
nwim = nwbuff + nk*nw + nwbuff;
imraw = zeros(nhim, nwim);

% simulate printing
kline = nhbuff + 1;
for k = 1:nh
  for kk = 1:nk
    sline = simchannel(spage(k,:), nk, linesnr, clip, jitt);
    nline = length(sline);
    imraw(kline, (nwbuff+1):(nwbuff+nline)) = sline;
    kline = kline + 1;
  end
end

% TODO: add scan noise
im = imraw;
