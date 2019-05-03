% Author: Chris Hemingway
% Part of matlab_rsa project

function c = vpi2char(n)
%VPI2CHAR convert VariablePrecisionInteger to character array
c = [];

assert(isa(n,'vpi'), "Input must be VariablePrecisionInteger");

% Extract chars in reverse order
while n > 0
   c = [char(double(mod(n,256))) c];
   n = n / 256;
end

end