%% Generate code

% test parameters
clearvars
filename = 'testpagecodes';
nbytes = 128*1024;
data = uint8(gensawbytes(nbytes));

% parameters
codepar.dpi = 98;
codepar.win = 6.5;  % inches
codepar.hin = 9;  % inches
codepar.linepix = 2;  % pixels per barcode frame

% remove old
try
  delete([filename '*.tif'])
catch err
  disp('no files to clean...')
end

%% Write TIFF file

writepagecode(data, codepar, filename);
