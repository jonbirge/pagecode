function xvec = encodechip(x)
% xvec = encodechip(x)
% where x is a two-bit unsigned integer

switch x
  case 0
    xvec = [0 1 0 1];
  case 1
    xvec = [1 0 1 0];
  case 2
    xvec = [0 0 1 1];
  case 3
    xvec = [1 1 0 0];
end
