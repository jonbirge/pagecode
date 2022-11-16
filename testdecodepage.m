%% Generate code

% test parameters
clearvars
nbytes = 16*1024;
data = uint8(gensawbytes(nbytes));

% parameters
codepar.dpi = 98;
codepar.win = 6.5;  % inches
codepar.hin = 9;  % inches
codepar.linepix = 2;  % pixels per barcode frame

% generate page
pageframes = floor(codepar.dpi*codepar.hin/codepar.linepix);
codim = encodepage(data, codepar);


%% Simulate print

% print parameters
printsnr = 4;
pwin = 8.5;
phin = 11;
wbuf = (pwin - codepar.win)/codepar.win;
hbuf = (phin - codepar.hin)/codepar.hin;
im = simpage(codim, printsnr, hbuf, wbuf);

% figure(1)
% imagesc(im)


%% Simulate scan

% TODO: simulate sampling the printed code with potential rotation, given a
% sampling dpi. include potential clipping and rotation.

imscan = logical(round(im));

% figure(2)
% imagesc(imscan)


%% Read and normalize simulated scan

dataout = decodepage(imscan);

figure(3)
plot(dataout)


%% Evaluation

nout = length(dataout);
if nout ~= nbytes
  fprintf('data lost!\n');
else
  errs = abs(dataout - data);
  nerrs = sum(errs > 0);
  fprintf('byte errors = %d\n', nerrs);
end
