%% Generate code

% test parameters
clearvars
try
  data = file2bytes('demo/testfile.jpg');
  nbytes = length(data);
  infilename = 'testfile.jpg';
  disp('reading from demo file...')
catch err
  nbytes = 128*1024;
  data = uint8(gensawbytes(nbytes));
  infilename = 'test.dat';
  delete('pagecode_*.tif')  % remove old
  disp('using ramp signal...')
end

% encode parameters
codepar.dpi = 98;
codepar.win = 7.5;  % inches
codepar.hin = 10;  % inches
codepar.linepix = 2;  % pixels per barcode frame

% print parameters
printsnr = 8;  % linear scale
pwin = 8.5;
phin = 11;
wbuf = (pwin - codepar.win)/codepar.win;
hbuf = (phin - codepar.hin)/codepar.hin;


%% save simulated scan image files

% dense pagination
pixperbyte = 4*8/2;  % coding specific
overheadpix = 5*pixperbyte;
pageframes = floor(codepar.dpi*codepar.hin/codepar.linepix);
framebytes = floor((codepar.dpi*codepar.win - overheadpix)/pixperbyte);
nframes = ceil(nbytes/framebytes);
npages = ceil(nframes/pageframes);

% actual even pagination
pagebytes = ceil(nbytes/npages);

disp('encoding pages in parallel...')
parfor kpage = 1:npages
  % encode
  idx1 = (kpage - 1)*pagebytes + 1;
  idx2 = min(idx1 + pagebytes - 1, nbytes);
  pagedata = data(idx1:idx2); %#ok<PFBNS> 
  codim = encodepage(pagedata, codepar, [infilename '#' num2str(kpage)]);

  % simulate print and scan
  im = simpage(codim, printsnr, hbuf, wbuf);
  imscan = logical(round(im));
  filename = ['pagecode_' num2str(kpage)];
  imwrite(~imscan, [filename '.tif']);
end
