function [ w_fg, w_gh, sse ] = epoch( input, output, w_fg, w_gh, num_patterns, learning_rate )
% FUNCTION: Computes the connection weights w_fg and w_gh for the
%  network mapping input -> output. Also returns final sse, after learning
%  is done
% PARAMS: 
%  input = array of input stimuli, 
%  output = array of the expected outputs for the given input, 
%  w_fg = original connection weights from f->g, 
%  w_gh = original connection weights from g->h, 
%  num_patterns = number of columns in [input], 
%  learning_rate = learning rate constant
% RETURNS: 
%  w_fg = connection weights from f->g after delta learning, 
%  w_gh = connection weights from g->h after delta learning, 
%  sse = sse of all the input patterns

% Loop through the model & learn
% % Choose a pattern randomly
pattern_pool = zeros(1, num_patterns);
for i = 1:num_patterns
    pattern_pool(:,i) = i;
end

while ~isempty(pattern_pool)
    ri = floor(rand*length(pattern_pool)) + 1;
    i = pattern_pool(ri);
    pattern_pool(ri) = [];
    
    input_to_hidden = w_fg * input(:,i);
    hidden_activation = activation_fn(input_to_hidden);
    input_to_output = w_gh * hidden_activation;
    output_activation = activation_fn(input_to_output);
    output_error = output(:,i) - output_activation;
   
    dw_gh = learning_rate * (diag(activation_fn_deriv(w_gh * hidden_activation)) * output_error) * hidden_activation';    
    dw_fg = learning_rate * diag(activation_fn_deriv(w_fg * input(:,i))) * w_gh' * output_error * diag(activation_fn_deriv(w_gh * hidden_activation)) * input(:,i)';
    
    w_gh = w_gh + dw_gh;
    w_fg = w_fg + dw_fg;
end

[all_output_errors, ~] = test_model(input, output, w_fg, w_gh, num_patterns);

sse = trace(all_output_errors' * all_output_errors);

end

