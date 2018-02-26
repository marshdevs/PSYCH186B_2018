%%% Homework 6 %%%

% Parameters
learning_rate = 1.0;
num_inputs = 8;
num_patterns = 8;
num_hidden = 3;
num_output = 1;

% Build input (patterns)
input = randn(num_patterns, num_inputs);
for i = 1:num_patterns
    for j = 1:num_inputs
        if input(i,j) < 0
            input(i,j) = 0;
        else
            input(i,j) = 1;
        end
    end
end

% Build output (odd/even)
output = zeros(num_patterns, 1);
for i = 1:num_patterns
    counter_ones = 0;
    for j = 1:num_inputs
        if input(i,j) == 1
            counter_ones = counter_ones + 1;
        end
    end
    output(i, 1) = ~mod(counter_ones, 2);
end

% Build weights (uniform, random numbers X | -0.5 < x < 0.5)
w_fg = (0.5 + 0.5).*rand(8, 3) - 0.5;
w_gh = (0.5 + 0.5).*rand(3, 1) - 0.5;

% Loop through the model
for i = 1:num_patterns
    input_to_hidden = input(i,:) * w_fg;
    hidden_activation = activation_fn(input_to_hidden);
    input_to_output = hidden_activation * w_gh;
    output_activation = activation_fn(input_to_output);
    output_error = output(i, :) - output_activation;
end

fprintf('stop');