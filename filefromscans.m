function filefromscans(fileprefix)

% input handling
if nargin < 1
  fileprefix = '[Untitled]';
end

ds = dir([fileprefix '*.tif']);
nf = length(ds);

% read and decode files
datapages = cell(nf, 1);
pagebytes = zeros(nf, 1);
for kf = 1:nf
  fprintf('reading page %d...\n', kf)
  imscan = imread(ds(kf).name);
  [datapage, filename, ~] = decodepage(imscan);
  datapages{kf} = datapage;
  pagebytes(kf) = length(datapage);
end

% concat data
% totalbytes = sum(pagebytes);
data = cat(2, datapages{:});

% save to disk
bytes2file(data, filename)

end
