function codim = encodepage(data, codeparams)

% parameters
dpi = codeparams.dpi;
win = codeparams.win;  % inches
linepix = codeparams.linepix;  % pixels per barcode frame

% constants
nbytes = length(data);
nchip = 4;
bitsperchip = 2;
pixperbyte = nchip*8/bitsperchip;
overheadpix = 5*nchip;
framebytes = floor((dpi*win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);

% TODO: put file name and file segment in header

% header frame
xhead = 42*ones(1, framebytes);
headfrm = encodeframe(xhead, 0);
framepix = length(headfrm);

% TODO: have encodeframe take an optional parameter that is the upper limit
% on line length, and return number of pixels used. build code iteratively.

% data frames
codim = false(linepix*(nframes + 1), framepix);
codim(1:linepix,:) = repmat(headfrm, linepix, 1);
for k = 1:nframes
  idx1 = (k-1)*framebytes + 1;
  idx2 = min(idx1 + framebytes - 1, nbytes);
  frmdat = data(idx1:idx2);
  frm = encodeframe(frmdat, k);
  linidx1 = k*linepix + 1;
  linidx2 = linidx1 + linepix - 1;
  codim(linidx1:linidx2,1:length(frm)) = repmat(frm, linepix, 1);
end
