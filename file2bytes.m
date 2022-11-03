function bytevec = file2bytes(filename)
% bytevec = file2bytes(filename)

fid = fopen(filename);
raw = fread(fid);
bytevec = uint8(raw).';
