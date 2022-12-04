function filetopagecode(infile, outfile, codepar)

if nargin < 3
  codepar = defaultpar();
  if nargin < 2
    outfile = 'pagecode';
    if nargin < 1
      [filename, pathname] = uigetfile('*.*', 'Pick a file to encode');
      if isequal(filename,0) || isequal(pathname,0)
        return
      else
        infile = fullfile(pathname, filename);
      end
    end
  end
end

% read file into data variable. TODO: read pages at a time
data = file2bytes(infile);
writepagecode(data, codepar, outfile);

end