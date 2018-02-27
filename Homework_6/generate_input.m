function [ input ] = generate_input( num_patterns, num_inputs )
% FUNCTION: Generate random input vector for the parity model given the 
%  dimensions of the desired vector
% PARAMS:  
%  num_patterns = number of columns in [input], 
%  num_inputs = number of rows in [input], 
% RETURNS: 
%  input = an [num_inputs x num_patterns] array containing discrete random 
%   values in [0,1]

% Build input (patterns)
input = randn(num_patterns, num_inputs);
for i = 1:num_patterns
    for j = 1:num_inputs
        if input(j,i) < 0
            input(j,i) = 0;
        else
            input(j,i) = 1;
        end
    end
end

end

