% Author: Chris Hemingway
% Part of matlab_rsa project

function c = rsa_encrypt(plaintext, Kp)
%RSA_ENCRYPT encrypts char/string plaintext to ciphertext c using public key Kp
%   c = rsa_encrypt(plaintext, Kp)
%   See also rsa_keygen, rsa_decrypt

% TODO padding
% TODO use Modular exponentiation instead

% Convert text to a number
if isa(plaintext, 'char') || isa(plaintext, 'string')
    p = char2vpi(plaintext);
else
    p = plaintext;
end

% Check input is not bigger than key
if length(plaintext) * 8 > ceil(log2(Kp.n))
    error("Plaintext is longer than key");
end

% Encrypt, c = p^e mod n
% Using Matlab powermod function as faster
c = powermod(p,Kp.e,Kp.n);

end


