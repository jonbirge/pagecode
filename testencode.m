%% Generate data

clearvars
nbytes = 12*1024;
data = uint8(gensawbytes(nbytes));

pixperbyte = 4*8/2;
overheadpix = 5*pixperbyte;
linepix = 2;  % pixels per barcode frame
dpi = 95;
win = 6.5;  % inches
hin = 9;  % inches
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

imwrite(~codim, 'testbar.tif');
