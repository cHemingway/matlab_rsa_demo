% Author: Chris Hemingway
% Part of matlab_rsa project

function [p,q] = rsa_find_primes(n_bits)
% RSA_FIND_PRIMES find two primes [p,q] where product is of size n_bits
% Not secure! Uses MATLABs insecure pseudorandom generator
%   [p,q] = rsa_find_primes(n_bits)
% Used for rsa_keygen

    % For debug, uncomment this line to get the same values each time
    %rng(1);
    
    % Maximum prime value, start with half the number of bits
    max_val = (2^(n_bits/2)) - 1;
    % Minimum size, TODO ensure prime is reasonably big
    min_val = 1; 
    
    % Generate random numbers between max_val and min_val, and check 
    % if they are prime, do this until we have two of them.
    % To enforce n_bits, update max_val once a prime is found so that the
    % _next_ prime does not take more than n_bits to represent.
    % This is faster than calling primes() as we don't need all of them
    % Faster option would be incremental search algorithm, see 
    % https://crypto.stackexchange.com/a/1971
    random_primes = [];
    attempt = 0;
    while length(random_primes) ~= 2
        val = randi([min_val, max_val]);
        % Check if prime and not already used
        if isprime(val) && ~any(find(random_primes==val))
                random_primes = [random_primes val];
                % Update max_val so _total_ is n_bits
                % We have to be careful to only round as late as possible
                % to ensure that we always hit n_bits in total
                n_bits = n_bits - log2(val);
                max_val = round(2^n_bits);
                min_val = round(2^(n_bits-1)) + 1; 
                continue;
        end
        % Exit eventually if we didn't find anything
        % FIXME: Can exit early sometimes as does not take finding same
        % prime twice into account, try rsa_find_primes(4) to demonstrate
        attempt = attempt + 1;
        if attempt > (max_val - min_val)
            error("Couldn't find 2 primes between %d and %d", min_val, max_val);
        end
    end
    
    % Output is our 2 random primes
    p = random_primes(1);
    q = random_primes(2);
end
    