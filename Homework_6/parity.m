%%% Homework 6 %%%

% Parameters
learning_rate = 1.0;
num_epochs = 1000;
num_inputs = 8;
num_patterns = 8;
num_hidden = 3;

% Build input (patterns)
input = generate_input(num_patterns, num_inputs);

% Build output (odd/even)
output = generate_output( num_patterns, num_inputs, input );

% Build weights (uniform, random numbers X | -0.5 < x < 0.5)
w_fg = (0.5 + 0.5).*rand(num_hidden, num_patterns) - 0.5;
w_gh = (0.5 + 0.5).*rand(num_output, num_hidden) - 0.5;

[output_errors_original, outputs_original] = test_model(input, output, w_fg, w_gh, num_patterns);

[ w_fg, w_gh, sse, report_epochs, report_errors ] = converge_weights(input, output, w_fg, w_gh, num_patterns, num_inputs, num_epochs, learning_rate);
while sse > 0.01
    fprintf('[PARITY: WARNING] SSE did not converge after 1000 Epochs. Re-running...');
    input = generate_input(num_patterns, num_inputs);
    output = generate_output(num_patterns, num_inputs, input);
    w_fg = (0.5 + 0.5).*rand(num_hidden, num_patterns) - 0.5;
    w_gh = (0.5 + 0.5).*rand(num_output, num_hidden) - 0.5;
    [ w_fg, w_gh, sse, report_epochs, report_errors ] = converge_weights(input, output, w_fg, w_gh, num_patterns, num_inputs, num_epochs, learning_rate);
end

[output_errors_trained, outputs_trained] = test_model(input, output, w_fg, w_gh, num_patterns);

new_input = generate_input(num_patterns, num_inputs);
new_output = generate_output(num_patterns, num_inputs, new_input);
[output_errors_new, outputs_new] = test_model(new_input, new_output, w_fg, w_gh, num_patterns);

% Covergence report
% i. Plot of the SSE as it changes over epochs
% ii. Output before-after comparison
% iii. Image of the desired matrix
% iv. Image of the output matrix
figure
subplot(2,2,1)
plot(report_epochs, report_errors)
title('i. # epoch vs. SSE')

subplot(2,2,2)
patterns_i = [1 2 3 4 5 6 7 8];
plot(patterns_i, output_errors_trained, patterns_i, output_errors_new, patterns_i, output_errors_original);
title('ii. Output errors');
fprintf('[PARITY: INFO] Mean abs output error before back propagation: %2f\n', mean(abs(output_errors_original)));
fprintf('[PARITY: INFO] Mean abs output error on trained input: %2f\n', mean(abs(output_errors_trained)));
fprintf('[PARITY: INFO] Mean abs output error on untrained input: %2f\n', mean(abs(output_errors_new)));

subplot(2,2,3)
imagesc(output);
title('iii. Desired output');

subplot(2,2,4)
imagesc(round(outputs_trained'));
title('iv. Actual output');

fprintf('stop');