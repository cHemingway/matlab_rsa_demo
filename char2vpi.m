% Author: Chris Hemingway
% Part of matlab_rsa project

function n = char2vpi(c)
%CHAR2VPI converts a character array or string to VariablePrecisionInteger
% Does not handle non-ASCII chars
if isa(c, 'string') % Convert strings
    c = char(c);
end

if length(c) > 8
    error("Only up to 8 characters supported");
end

n = vpi();
for v=c
    n = n+uint8(v); %Get 8-bit value of character and add to array
    n = n * 256; %Shift number along by 8 bits
end

end