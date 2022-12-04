%% read file

clearvars
imraw = imread('testscan.tif');


%% measure & normalize

% TODO: rewrite using final functions. until then, forget about this file.

% TODO: should check if image is binary, and if not, high-pass and quantize
% the data to logical array.

% get rid of trivial white-space
[nh, nw] = size(imraw);
rowsum = sum(~imraw, 2);
improc = imraw(rowsum > 32, :);

% find fiducial edges. this is not a robust algorithm.
[nhp, ~] = size(improc);
k0 = zeros(1, nhp);
for k = 1:nhp
  imline = ~improc(k,:);
  k0(k) = find(imline,1);
end

% remove outliers beyond 10 pixels
kmed = median(k0, 'omitnan');
k0(abs(k0 - kmed) > 10) = NaN;

figure(1)
plot(k0)

% fit line to edges, assuming square pixels
lm = fitlm(1:nhp, k0);
figure(2)
plot(lm)
slope = lm.Coefficients.Estimate(2);

% square edges
whitesp = ceil(min(predict(lm, (1:nhp).')));  % how lazy am i?
imcrop = improc(1:end, whitesp:end);


%% read lines

% TODO: we either need to collapse
% everything to a logical earlier, or figure out a way to handle
% grey-scale. one option would be to pull out the preprocess code from
% decode frame and put it here, and have that handle decide what's a line
% and what's not.

% TODO: read all similar lines into buffer and vote.

% read lines, assuming imraw is logical
[nhc, ~] = size(imcrop);
rawdata = {};
dataline = 1;
for k = 1:nhc
  if mod(k, 100) == 0
    fprintf('k: %d\n', k)
  end
  if ~isnan(k0(k))
    imline = ~imcrop(k,:);
    [xs, nsamp] = decodeframe(imline);
    rawdata{dataline} = xs; %#ok<SAGROW>
    dataline = dataline + 1;
  end
end
