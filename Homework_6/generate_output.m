function [ output ] = generate_output( num_patterns, num_inputs, input )
% FUNCTION: Generate output vector for the parity model given the 
%  provided input vector
% PARAMS:  
%  num_patterns = number of columns in [input], 
%  num_inputs = number of rows in [input], 
%  input = vector to generate output for
% RETURNS: 
%  output = an [1 x num_patterns] array, where A[1,i] = ~mod(ones(i), 2),
%   where ones(i) equals the number of ones in row i of input

% Build output (odd/even)
output = zeros(1, num_patterns);
for i = 1:num_patterns
    counter_ones = 0;
    for j = 1:num_inputs
        if input(j,i) == 1
            counter_ones = counter_ones + 1;
        end
    end
    output(1, i) = ~mod(counter_ones, 2);
end
end

