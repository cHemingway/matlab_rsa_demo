% Author: Chris Hemingway
% Part of matlab_rsa project

function plaintext = rsa_decrypt(c, Ks)
%RSA_DECRYPT decrypt VariablePrecisionInt c using private key Ks to chars
% plaintext = rsa_decrypt(c, Ks)
%   See also rsa_keygen, rsa_decrypt

% Decrypt, p = c^d mod n
% Using Matlab powermod function as faster
p = powermod(c,Ks.d,Ks.n);

% Convert from number back to chars
plaintext = vpi2char(p);

end