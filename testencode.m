%% Generate data

clearvars
nbytes = 8*1024;
data = uint8(randi(255, 1, nbytes));


%% Parameters

pixperbyte = 4*8/2;
overheadpix = 5*pixperbyte;
linepix = 5;  % pixels per barcode frame
dpi = 150;
win = 6;  % inches
hin = 8;  % inches
pageframes = floor(dpi*hin/linepix);
framebytes = floor((dpi*win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);


%% Generate codes

% header frame
xhead = ones(1, framebytes);
headfrm = encodeframe(xhead, 1);
framepix = length(headfrm);

% all frames
codim = false(linepix*(nframes + 1), framepix);
codim(1:linepix,:) = repmat(headfrm, linepix, 1);
for k = 1:nframes
  idx1 = (k-1)*framebytes + 1;
  idx2 = min(idx1 + framebytes - 1, nbytes);
  frmdat = data(idx1:idx2);
  frm = logical(encodeframe(frmdat, k + 1));
  linidx1 = k*linepix;
  linidx2 = linidx1 + linepix - 1;
  codim(linidx1:linidx2,1:length(frm)) = repmat(frm, linepix, 1);
end

imwrite(codim, 'testbar.tiff');
