function [dataout, filename, seqid] = decodepage(imscan)

% TODO: should check if image is binary, and if not, high-pass and quantize
% the data to logical array.
imraw = ~imscan;

% get rid of trivial white-space
rowsum = sum(imraw, 2);
improc = imraw(rowsum > 32, :);

% find fiducial edges. (this is not a robust algorithm.)
[nhp, ~] = size(improc);
k0 = zeros(1, nhp);
for k = 1:nhp
  imline = improc(k,:);
  k0(k) = find(imline,1);
end

% remove outliers beyond 10 pixels
kmed = median(k0, 'omitnan');
k0(abs(k0 - kmed) > 10) = NaN;
knans = isnan(k0);
xs = 1:nhp;
k0(knans) = [];
xs(knans) = [];

% fit line to edges, assuming square pixels
p = polyfit(xs, k0, 1);

% square edges
whitesp = ceil(min(polyval(p, (xs).')));
imcrop = improc(1:end, whitesp:end);

% determine sample rate from header lines
nclock = 8;  % number of lines to average clock
nsamps = zeros(1, nclock);
for ks = 1:nclock
  nsamps(ks) = clocksync(imcrop(1 + ks,:));
end
nsamp = median(nsamps);

% TODO: we either need to collapse everything to a logical earlier, or
% figure out a way to handle grey-scale. one option would be to pull out
% the preprocess code from decode frame and put it here, and have that
% handle decide what's a line and what's not.

% TODO: read all similar lines into buffer and vote.

% decode lines, assuming 'imcrop' is logical/binary
[nhc, ~] = size(imcrop);
rawdata = {};
ids = [];
dataline = 1;
for k = 1:nhc
  %if mod(k, 100) == 0
  %  fprintf('k: %d\n', k)
  %end
  if ~isnan(k0(k))
    dataout = decodeframe(imcrop(k,:), nsamp);
    rawdata{dataline} = dataout(2:end); %#ok<AGROW>
    ids(dataline) = dataout(1); %#ok<AGROW> 
    dataline = dataline + 1;
  end
end

% for now, just take the first id, and make the assumption that all ids are
% valid and that the only job is to take the first and move on. in the
% future, a more robust id system could be developed, and all lines voted
% with the same id would vote per chip. eventually we should encode the
% number of lines in the header, and use crc bytes on each line...

% extract header info
headerstr = char(rawdata{3});  % conservatively assume the third line is correct
A = regexp(headerstr, '(?<file>.*)#(?<id>\d+)', 'names');
filename = A.file;
seqid = A.id;

% combine data lines
nids = length(ids);  % number of lines decoded
dataout = [];
lastid = 0;
for k = 1:nids
  id = ids(k);
  if id ~= lastid
    dataout = [dataout, rawdata{k}]; %#ok<AGROW>
    lastid = id;
  end
end
