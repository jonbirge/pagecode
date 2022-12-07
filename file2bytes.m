function bytevec = file2bytes(filename)
%FILE2BYTES  Read uint8 array from binary file

fid = fopen(filename);
raw = fread(fid);
bytevec = uint8(raw).';

end