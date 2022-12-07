%% generate simulated signal

% coding params
clearvars
% nchip = 4;  % number of symbols in chip

% sim params
ndat = 128;  % number of bytes in frame
nk = 8;  % number of samples per symbol
snr = 10;
clip = randi(24);  % number of samples to clip on each end
jitter = 0.25;

xs = gentestbytes(ndat);  % pattern bytes
frm = encodeframe(xs);
sraw = simchannel(frm, nk, snr, clip, jitter);

plot(sraw(1:min(256,length(sraw))))


%% decode

xs = decodeframe(sraw);


%% check errors

plot(xs, '.-')
