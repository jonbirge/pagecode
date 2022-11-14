%% Generate data

clearvars
nbytes = 16*1024;
data = uint8(gensawbytes(nbytes));

% parameters
dpi = 98;
win = 6.5;  % inches
hin = 9;  % inches
linepix = 2;  % pixels per barcode frame
printsnr = 10;

nchip = 4;
bitsperchip = 2;
pixperbyte = nchip*8/bitsperchip;
overheadpix = 5*nchip;
pageframes = floor(dpi*hin/linepix);
framebytes = floor((dpi*win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);


%% Generate codes

% header frame, will eventually have file name
xhead = 42*ones(1, framebytes);
headfrm = encodeframe(xhead, 0);
framepix = length(headfrm);

% all frames
codim = false(linepix*(nframes + 1), framepix);
codim(1:linepix,:) = repmat(headfrm, linepix, 1);
for k = 1:nframes
  idx1 = (k-1)*framebytes + 1;
  idx2 = min(idx1 + framebytes - 1, nbytes);
  frmdat = data(idx1:idx2);
  frm = logical(encodeframe(frmdat, k));
  linidx1 = k*linepix + 1;
  linidx2 = linidx1 + linepix - 1;
  codim(linidx1:linidx2,1:length(frm)) = repmat(frm, linepix, 1);
end


%% Simulate print

pwin = 8.5;
phin = 11;
wbuf = (pwin - win)/win;
hbuf = (phin - hin)/hin;
im = simpage(codim, printsnr, hbuf, wbuf);

% figure(1)
% imagesc(im)


%% Simulate scan

% TODO: simulate sampling the printed code with potential rotation, given a
% sampling dpi. include potential clipping and rotation.

imscan = logical(round(im));

% figure(1)
% imagesc(imscan)


%% Read and normalize simulated scan

% TODO: should check if image is binary, and if not, high-pass and quantize
% the data to logical array.

% get rid of trivial white-space
[nh, nw] = size(imscan);
rowsum = sum(imscan, 2);
improc = imscan(rowsum > 32, :);

% find fiducial edges. (this is not a robust algorithm.)
[nhp, ~] = size(improc);
k0 = zeros(1, nhp);
for k = 1:nhp
  imline = improc(k,:);
  k0(k) = find(imline,1);
end

% remove outliers beyond 10 pixels
kmed = median(k0, 'omitnan');
k0(abs(k0 - kmed) > 10) = NaN;

% figure(1)
% plot(k0)

% fit line to edges, assuming square pixels
lm = fitlm(1:nhp, k0);
figure(1)
plot(lm)
slope = lm.Coefficients.Estimate(2);

% square edges
whitesp = ceil(min(predict(lm, (1:nhp).')));  % how lazy am i?
imcrop = improc(1:end, whitesp:end);

% plot cropped result
figure(2)
imagesc(imcrop)


%% Decode lines

% TODO: we either need to collapse
% everything to a logical earlier, or figure out a way to handle
% grey-scale. one option would be to pull out the preprocess code from
% decode frame and put it here, and have that handle decide what's a line
% and what's not.

% TODO: read all similar lines into buffer and vote.

% read lines, assuming 'imcrop' is logical
[nhc, ~] = size(imcrop);
rawdata = {};
ids = [];
dataline = 1;
for k = 1:nhc
  if mod(k, 100) == 0
    fprintf('k: %d\n', k)
  end
  if ~isnan(k0(k))
    imline = imcrop(k,:);
    [xs, nsamp] = decodeframe(imline);
    rawdata{dataline} = xs(2:end); %#ok<SAGROW>
    ids(dataline) = xs(1); %#ok<SAGROW> 
    dataline = dataline + 1;
  end
end


%% Combine lines

% for now, just take the first id, and make the assumption that all ids are
% valid and that the only job is to take the first and move on. in the
% future, a more robust id system could be developed, and all lines voted
% with the same id would vote per chip.
nids = length(ids);  % number of lines decoded
xs = [];
lastid = 0;
kline = 1;
for k = 1:nids
  id = ids(k);
  if id ~= lastid
    xs = [xs, rawdata{kline}]; %#ok<AGROW>
    lastid = id;
    kline = kline + 1;
  end
end

figure(3)
plot(xs)
