% Author: Chris Hemingway
% Part of matlab_rsa project

function [Kp, Ks] = rsa_keygen(n_bits)
% RSA_KEYGEN generate public/private key structs of size n_bits
% Warning,  >52 bits not possible due to MATLAB limitations
%
%   [Kp,Ks] = rsa_keygen(8); % Generate 10 bit key
%   disp(Kp.n)    % Get base of public key
%   8             % Base is same as n_bits
%   disp(Kp.e)    % Public key exponent
%   ...           % Will be random

% Check input is sensible
if n_bits > 53
   error("Value of n_bits too large"); 
end

% Find p,q
[p,q] = rsa_find_primes(n_bits);

% Calculate base
n = p * q; % Base is _product_ of these
% assert(ceil(log2(n)) == n_bits);

% Calculate max exponent size
% This is ?(n), Carmicheals Totient Function of n
% <https://en.wikipedia.org/wiki/Carmichael_function>
% However, since p and q are both prime, we can use the following instead
X = (p-1) * (q-1);


% Choose public exponent e, where 1<e<x and gcd(e,x) == 1
% Small values make encryption quicker, so start low and work up
for e=2:X-1
    if gcd(e,X) == 1
        break;
    end
end
assert(e~=X-1); % Check we actually found something

% Find d so $d \times e mod X = 1$
% Very slow brute force approach, but easy to verify correct
%{
for d=1:n
    if mod(d*e,X) == 1
        break;
    end
end
assert(d~=n);
%}

% Faster alternative, VPI library has suitable function
d = minv(e, X);
assert(mod(d*e,X) == 1);


% Combine base n and exponent e to create public key
Kp.n = n;
Kp.e = e;

% Combine base n and secret d to create private key
Ks.n = n;
Ks.d = d;
end