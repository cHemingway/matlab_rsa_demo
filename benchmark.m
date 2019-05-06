img = imread("cameraman.tif");
[Kp, Ks] = rsa_keygen(32);


disp("Benchmark CBC Encryption");
[height, width] = size(img);
encrypted_image = zeros([height,width/4]);
last_block = uint32(iv);

for i=1:height
    for j=1:4:width
        % Combine pixels into block
        block = uint32(0);
        for k=0:3
            block = bitshift(block,8);
            block = bitor(block,uint32(img(i,j+k)));
        end
        % XOR with previous block
        block = bitxor(block, last_block);
        % Encrypt
        encrypted_block = powermod(p, Kp.e, Kp.n); %Speed up by calling powermod directly
        % Save
        output_column = round(j/4) + 1;
        encrypted_image(i,output_column) = encrypted_block;
        last_block = uint32(double(encrypted_block)); %Have to cast to double first
    end
end

disp ("Benchmark CBC Decryption");
decrypted_image = zeros([height,width]);
last_block = uint32(iv);

for i=1:height
    for j=1:4:width
        input_column = round(j/4) + 1;
        encrypted_block = encrypted_image(i,input_column);
        % Decrypt
        block = powermod(encrypted_block, Ks.d, Ks.n); %Speed up by calling powermod directly
        block = uint32(double(block)); % Convert to uint32
        
        % XOR back
        block = bitxor(block, last_block);
        
        % Save block
        last_block = uint32(double(encrypted_block));
        
        % Split decoded block into pixels
        for k=0:3
            col = j+(3-k); % -k as going in _reverse_ direction per block
            decrypted_image(i,col) = bitand(block, 255);
            block = bitshift(block,-8); % Right shift
        end
    end
end

% Takes a very long time, so play a noise when done
load gong, sound(y,2*Fs)