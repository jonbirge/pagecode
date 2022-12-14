function frm = encodeframe(xs, n)
% framesig = frameline(xs)

% parameters
term = [ones(1,4) zeros(1,4)];

% build redundant frame
nbyte = mod(n, 256);
sig = encodebytes([uint8(nbyte) xs]);
frm = logical([term term term sig term term]);

end
