function writepagecode(data, codepar, filename)
%WRITEPAGECODE  Write data into TIFF pagecodes

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

% TODO: write multipage TIFF
for kpage = 1:npages
  idx1 = (kpage - 1)*pagebytes + 1;
  idx2 = min(idx1 + pagebytes - 1, nbytes);
  pagedata = data(idx1:idx2);
  codim = encodepage(pagedata, codepar);
  thisfilename = [filename '_' num2str(kpage) '.tif'];
  imwrite(~codim, thisfilename);
end

end
