%% read test files

clearvars

ds = dir('*.tif');
nf = length(ds);

datapages = cell(nf, 1);
pagebytes = zeros(nf, 1);

parfor kf = 1:nf
  imscan = imread(ds(kf).name);
  datapage = decodepage(imscan);
  datapages{kf} = datapage;
  pagebytes(kf) = length(datapage);
end

totalbytes = sum(pagebytes);
data = cat(2, datapages{:});


%% data integrity check

% we'll assume a ramp function was the original data input
diffs = diff(double(data));
errs = find(abs(diffs) ~= 1);
nerr = length(errs);
if nerr > 0
  warning('data errors')
  fprintf('byte errors = %d\n', nerr)
  figure(1)
  plot(errs)
else
  disp('no apparent errors in data!')
end
