%% Generate code

% test parameters
clearvars
filename = 'pagecodes.tif';
nbytes = 32*1024;
data = uint8(gensawbytes(nbytes));

% parameters
codepar.dpi = 98;
codepar.win = 6.5;  % inches
codepar.hin = 9;  % inches
codepar.linepix = 2;  % pixels per barcode frame


%% save image files
% TODO: factor into function to write single file

% remove old
delete(filename)

% dense pagination
pixperbyte = 4*8/2;  % coding specific
overheadpix = 5*pixperbyte;
pageframes = floor(codepar.dpi*codepar.hin/codepar.linepix);
framebytes = floor((codepar.dpi*codepar.win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);
npages = ceil(nframes/pageframes);

% actual even pagination
pagebytes = ceil(nbytes/npages);

% TODO: write multipage TIFF
% TODO: use parfor?
for kpage = 1:npages
  idx1 = (kpage - 1)*pagebytes + 1;
  idx2 = min(idx1 + pagebytes - 1, nbytes);
  pagedata = data(idx1:idx2);
  codim = encodepage(pagedata, codepar);
  filename = ['pagecode_' num2str(kpage)];
  imwrite(~codim, [filename '.tif']);
end
