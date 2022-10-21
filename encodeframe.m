function frm = encodeframe(xs)
% framesig = frameline(xs)

% parameters
term = [ones(1,4) zeros(1,4) ones(1,4) zeros(1,4)];

% build redundant frame
sig = encodebytes(xs);
frm = [term sig term sig term sig term];

end
