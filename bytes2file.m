function bytes2file(data, filename)
%BYTES2FILE  Write uint8 bytes to a binary file

fid = fopen(filename, 'W');
fwrite(fid, data, 'uint8');
fclose(fid);

end