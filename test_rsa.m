% Author: Chris Hemingway
% Part of matlab_rsa project

clear; clc;

% Demonstration, creates keys, encrypts a message, then decrypts

% Use VariablePrecisionIntegers library
% From John D'Errico, 2-Clause BSD license, source:
% <https://uk.mathworks.com/matlabcentral/fileexchange/22725-variable-precision-integer-arithmetic>
addpath(['VariablePrecisionIntegers' filesep 'VariablePrecisionIntegers']);

% Should we print some execution times?
show_timings = false;

% Message, has to use less bits than the key size
message = 'Hello';

% Generate keys, 48 bit
[Kp, Ks] = rsa_keygen(48);

fprintf("Generated %d bit public/private keypair \n",length(dec2bin(Kp.n)));

% Encrypt
c = rsa_encrypt(message, Kp);
fprintf("Encrypted: '%s' to c=",message);
disp(c); % Have to use disp as VPI does not support plaintext

% Count bits of codeword, may or may not match key length
fprintf("Codeword is %d bits long\n", length(vpi2bin(c)) );

% Decrypt
tic;
plaintext = rsa_decrypt(c, Ks);
decrypt_time = toc;
fprintf("Decrypted: '%s' \n", plaintext);

% Simulate single bit error, flip LSB
% Note this will give different garbage every time key changes
if mod(c,2)==0 %Even, LSB not set
    c_error = c+1;
else
    c_error = c-1;
end

fprintf("Single bit error in codeword, decrypted to '%s' \n",rsa_decrypt(c_error,Ks));

% Time "cracking" the code
tic;
factors = factor(Kp.n); %Built in matlab function to get prime factors
factor_time = toc;

% Can show time here, but VPI is quite slow, so factorising is actually
% fairly good compared to decryption, even though it should be very slow.
if show_timings
    fprintf("Factored public base n = ");
    disp(factor(Kp.n));
    fprintf("Factorising took %2.3e, decrypting with private key took %2.3e\n",...
        factor_time, decrypt_time);
end