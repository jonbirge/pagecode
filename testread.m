%% read file

clearvars
imraw = imread('testscan.tif');


%% measure & normalize

% should check if image is binary, and if not, high-pass and quantize it

% im = double(imraw) - 0.5;
[nh, nw] = size(imraw);


%%

k0 = zeros(1, nh);
for k = 1:nh
  sline = double(~imraw(k, :));
  if sum(sline) == 0
    k0(k) = NaN;  % drop line
  else
    k0(k) = find(sline, 1);
  end
end

kmed = median(k0, 'omitnan');
k0(abs(k0 - kmed) > 10) = NaN;

figure(1)
plot(k0)