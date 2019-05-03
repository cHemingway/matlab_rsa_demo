% Author: Chris Hemingway
% Part of matlab_rsa project

% Demonstration, creates keys, encrypts a message, then decrypts

% Use VariablePrecisionIntegers library
% From John D'Errico, 2-Clause BSD license, source:
% <https://uk.mathworks.com/matlabcentral/fileexchange/22725-variable-precision-integer-arithmetic>
addpath(['VariablePrecisionIntegers' filesep 'VariablePrecisionIntegers']);

% Message, has to use less bits than the key size
message = 'Fnord';

% Generate keys, 48 bit
[Kp, Ks] = rsa_keygen(48);

% Encrypt
c = rsa_encrypt(message, Kp);
fprintf("Encrypted: '%s' to c=",message);
disp(c); % Have to use disp as VPI does not support plaintext

% Decrypt
plaintext = rsa_decrypt(c, Ks);
fprintf("Decrypted: '%s' \n", plaintext);

% Simulate single bit error, flip LSB
% Note this will give different garbage every time key changes
if mod(c,2)==0 %Even, LSB not set
    c_error = c+1;
else
    c_error = c-1;
end

fprintf("Flipping a bit, decoded to '%s' \n",rsa_decrypt(c_error,Ks));