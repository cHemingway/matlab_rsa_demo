% Author: Chris Hemingway
% Part of matlab_rsa project

function plaintext = rsa_decrypt(c, Ks, varargin)
%RSA_DECRYPT decrypt VariablePrecisionInt c using private key Ks to chars
%   plaintext = rsa_decrypt(c, Ks)
%
%   By default, it will presume you are decrypting text. To disable
%   number = rsa_decrypt(c, Ks, 'isText', false);
%   See also rsa_keygen, rsa_decrypt


% Check inputs
defaultisText = true;
parser = inputParser;
addParameter(parser,'isText',defaultisText, @islogical);
parse(parser,varargin{:});

% Decrypt, p = c^d mod n
% Using Matlab powermod function as faster
p = powermod(c,Ks.d,Ks.n);

if parser.Results.isText
    % Convert from number back to chars
    plaintext = vpi2char(p);
else
    % Don't convert it
    plaintext = p;

end