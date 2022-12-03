%% read test files

clearvars

ds = dir('*.tif');
nf = length(ds);

datapages = cell(nf, 1);

for kf = 1:nf
  imscan = imread(ds(kf).name);
  datapages{kf} = decodepage(imscan);
end


%% concatenate pages of data

