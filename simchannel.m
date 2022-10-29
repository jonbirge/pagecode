function s = simchannel(frm, nk, snr, clip, jitt)
% s = simchannel(frm, nk, snr, clip)
% where frm is the frame of binary values to encode, nk is the number of samples to
% include per symbol, snr is the signal-to-noise ratio, and clip is the
% number of samples to simulate clipping at the beginning and end of the
% frame (to simulate margin cut-off on a printer), and jitter is the number
% of pixels of jitter to simulate each symbol.

if nargin < 5
  jitt = 0;
end
n = length(frm);  % number of bytes
krn = ones(1, nk);  % kernel representing a printed symbol

s = zeros(1, n*nk + ceil(10*sqrt(n)*jitt));  % the output signal with buffer
for k = 1:n
  if k == 1  % no jitter yet
    idx = 1;
  else
    idx = (k-1)*nk + 1 + round(randn()*jitt);  % starting index
  end
  s(idx:idx+nk-1) = double(s(idx:idx+nk-1) | krn*double(frm(k))) + randn(1, nk)/sqrt(nk)/snr;
end

s(1:clip) = [];
s(end-clip:end) = [];
