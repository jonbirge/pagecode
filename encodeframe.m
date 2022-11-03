function frm = encodeframe(xs)
% framesig = frameline(xs)

% parameters
term = [ones(1,4) zeros(1,4)];

% build redundant frame
sig = encodebytes(xs);
frm = [term term term sig term term];

end
