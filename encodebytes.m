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
  bcode = uint8(zeros(bytechips, chipsize));
  cs = bytetochips(xints(kb));
  for k = 1:bytechips
    bcode(k,:) = encodechip(cs(k));
  end
  idx = bc*(kb-1)+1;
  bcodes(idx:idx+bc-1) = reshape(bcode.', 1, bc);
end

end


function cs = bytetochips(b)
% convert byte to array of chip integers. currently assumes 2-bit chips,
% but this should be generalized in the future.

chipbit = 2;
bytechips = 4;
tb = 0b11;
cs = zeros(1, bytechips);
for kc = 1:bytechips
 cs(bytechips - kc + 1) = bitand(tb, b);
 b = bitshift(b, -chipbit);
end

end