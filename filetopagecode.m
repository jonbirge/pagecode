function filetopagecode(outfile, codepar)

if nargin < 2
  codepar = defaultpar();
  if nargin < 1
    outfile = 'pagecode';
  end
end

% read file into data variable. TODO: read incrementally
[filename, pathname] = uigetfile('*.*', 'Pick a file to encode');
if isequal(filename,0) || isequal(pathname,0)
  return
else
  infile = fullfile(pathname, filename);
end
data = file2bytes(infile);

% write codes
writepagecode(data, codepar, outfile, filename);

end
