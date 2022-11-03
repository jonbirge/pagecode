function bcodes = encodebytes(xints)
% bcode = encodebytes(xints)
% where xint is no bigger than a byte

% parameters
chipbit = 2;  % bits represented per chip
chipsize = 4;  % symbols per chip
bytechips = 8/chipbit;

% constants
n = length(xints);
bc = bytechips*chipsize;

% convert
bcodes = uint8(zeros(1, n*bc)); 
for kb = 1:n
  bits = int2bit(xints(kb));
  bcode = zeros(bytechips, chipsize);
  for k = 1:bytechips
    idx = chipbit*(k-1)+1;
    chipcode = bit2int(bits(idx:idx+chipbit-1), chipbit);  % int to encode
    bcode(k, :) = encodechip(chipcode);
  end
  idx = bc*(kb-1)+1;
  bcodes(idx:idx+bc-1) = uint8(reshape(bcode.', 1, bc));
end

end

function x = bit2int(b, nb)
bstr = '';
for k = 1:nb
  bstr(k) = num2str(b(k));
end
x = bin2dec(bstr);
end

function b = int2bit(x)
bstr = dec2bin(x, 8);
b = zeros(1, 8);
for k = 1:8
  b(k) = str2double(bstr(k));
end
end
