function writepagecode(data, codepar, outfile, filename)
%WRITEPAGECODE  Write data into TIFF pagecodes

% input handling
if nargin < 4
  filename = 'pagecode.dat';
end

% initial dense pagination
pixperbyte = 4*8/2;  % coding specific
overheadpix = 5*pixperbyte;
pageframes = floor(codepar.dpi*codepar.hin/codepar.linepix);
framebytes = floor((codepar.dpi*codepar.win - overheadpix)/pixperbyte);
nbytes = length(data);
nframes = ceil(nbytes/framebytes);
npages = ceil(nframes/pageframes);

% even pagination
pagebytes = ceil(nbytes/npages);

% write multipage TIFF
outfilename = [outfile '.tif'];
try
  delete(outfilename);
  fprintf('deleting existing file...\n')
catch 
  fprintf('creating new file...\n')
end
for kpage = 2:npages
  idx1 = (kpage - 1)*pagebytes + 1;
  idx2 = min(idx1 + pagebytes - 1, nbytes);
  pagedata = data(idx1:idx2);
  codim = encodepage(pagedata, codepar, [filename '#' num2str(kpage)]);
  imwrite(~codim, outfilename, "WriteMode", "append");
  fprintf('page %d of %d\n', kpage, npages)
end

end
