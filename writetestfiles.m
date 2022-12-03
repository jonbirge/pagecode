%% Generate code

% test parameters
clearvars
nbytes = 32*1024;
data = uint8(gensawbytes(nbytes));

% parameters
codepar.dpi = 98;
codepar.win = 6.5;  % inches
codepar.hin = 9;  % inches
codepar.linepix = 2;  % pixels per barcode frame


%% save image files

% remove old
delete('pagecode_*.tif')

% dense pagination
pixperbyte = 4*8/2;  % coding specific
overheadpix = 5*pixperbyte;
pageframes = floor(codepar.dpi*codepar.hin/codepar.linepix);
framebytes = floor((codepar.dpi*codepar.win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);
npages = ceil(nframes/pageframes);

% actual even pagination
pagebytes = ceil(nbytes/npages);

for kpage = 1:npages
  idx1 = (kpage - 1)*pagebytes + 1;
  idx2 = min(idx1 + pagebytes, nbytes);
  pagedata = data(idx1:idx2);
  codim = encodepage(pagedata, codepar);
  filename = ['pagecode_' num2str(kpage)];
  imwrite(~codim, [filename '.tif']);
end
