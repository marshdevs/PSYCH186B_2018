function [ all_output_errors, all_outputs ] = test_model( input, output, w_fg, w_gh, num_patterns )
% FUNCTION: Computes the errors for the model's predictions given output,
%  input and the connection weights
% PARAMS: 
%  input = array of input stimuli, 
%  output = array of the expected outputs for the given input, 
%  w_fg = original connection weights from f->g, 
%  w_gh = original connection weights from g->h, 
%  num_patterns = number of columns in [input], 
% RETURNS: 
%  all_output_errors = for i:num_patterns, the difference between the
%   expected output and the output predicted by the model

% Test weights on given input and output
all_outputs = [];
all_output_errors = [];
for i = 1:num_patterns
    input_to_hidden = w_fg * input(:,i);
    hidden_activation = activation_fn(input_to_hidden);
    input_to_output = w_gh * hidden_activation;
    output_activation = activation_fn(input_to_output);
    output_error = output(:,i) - output_activation;
    
    all_outputs = [all_outputs; output_activation];
    all_output_errors = [all_output_errors; output_error];
end

end

