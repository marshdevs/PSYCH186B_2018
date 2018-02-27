function [ w_fg, w_gh, sse, report_epochs, report_errors ] = converge_weights( input, output, w_fg, w_gh, num_patterns, num_inputs, num_epochs, learning_rate )
% FUNCTION: Computes the final connection weights w_fg and w_gh for the
%  network mapping input -> output. Also returns the final sse, given the
%  computed weights.
% PARAMS: 
%  input = array of input stimuli, 
%  output = array of the expected outputs for the given input, 
%  w_fg = original connection weights from f->g, 
%  w_gh = original connection weights from g->h, 
%  num_patterns = number of columns in [input], 
%  num_inputs = number of rows in [input], 
%  num_epochs = number of epochs/trials to run, 
%  learning_rate = learning rate constant
% RETURNS: 
%  w_fg = final connection weights from f->g, 
%  w_gh = final connection weights from g->h, 
%  sse = final sse after <num_epochs trials,
%  report_epochs = trial number of each generated report,
%  report_errors = value of sse at each generated report

sse = 0;
report_epochs = [];
report_errors = [];
for i = 1:num_epochs
    [ w_fg, w_gh, sse ] = epoch(input, output, w_fg, w_gh, num_patterns, learning_rate);
    if ~mod(i,10)
        fprintf('[CONVERGE_WEIGHTS: INFO] Epoch: %d, SSE: %2f\n', i, sse);
        report_epochs = [report_epochs; i];
        report_errors = [report_errors; sse];
    end
    
    if sse < 0.01
        break;
    end
end

end

