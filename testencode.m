%% Generate data

clearvars
nbytes = 20*1024;
data = uint8(randi(255, 1, nbytes));


%% Generate barcode

pixperbyte = 4*8/2;
overheadpix = 5*pixperbyte;
linepix = 10;  % pixels per barcode frame
dpi = 200;
win = 6;  % inches
hin = 8;  % inches
pageframes = floor(300*8/linepix);
framebytes = floor((300*6 - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);

% header frame
xhead = ones(1, framebytes);
headfrm = encodeframe(xhead);
framepix = length(headfrm);

% all frames
codim = uint8(zeros(nframes + 1, framepix));
codim(1,:) = headfrm;
for k = 1:nframes
  idx1 = (k-1)*framebytes + 1;
  idx2 = min(idx1 + framebytes - 1, nbytes);
  frmdat = data(idx1:idx2);
  frm = encodeframe(frmdat);
  codim(k+1,1:length(frm)) = frm;
end


%% Save to file

imagesc(1 - codim)
colormap('gray')
