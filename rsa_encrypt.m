function c = rsa_encrypt(plaintext, Kp, varargin)
%RSA_ENCRYPT encrypts char/string plaintext to ciphertext c using public key Kp
%   c = rsa_encrypt(plaintext, Kp)
%
%   Length checking can also be disabled (enabled by default)
%   rsa_encrypt(very_long_message,Kp,'checkLength',false)
%
%   See also rsa_keygen, rsa_decrypt

% TODO use binary modular exponentiation instead of needing VPI library


% Convert text to a number
if isa(plaintext, 'char') || isa(plaintext, 'string')
    p = char2vpi(plaintext);
else
    p = plaintext;
end

% Check inputs
defaultcheckLength = false;
parser = inputParser;
addParameter(parser,'checkLength',defaultcheckLength, @islogical);

parse(parser,varargin{:});


% Check input is not bigger than key
if parser.Results.checkLength
    if length(plaintext) * 8 > ceil(log2(Kp.n))
        error("Plaintext is longer than key");
    end
end

% We have not added padding, which effectively means zero padding is used

% Encrypt, c = p^e mod n
% Using Matlab powermod function as faster
c = powermod(p,Kp.e,Kp.n);

end

% Author: Chris Hemingway
% Part of matlab_rsa project


