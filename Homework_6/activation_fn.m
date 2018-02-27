function [ activation ] = activation_fn( x )
% FUNCTION: Generic, non-linear connectionist unit
%  Sigmoid function: Monotonically increasing, differentiable, bounded
%   between (-1, 1).
% PARAMS:
%  x = input vector
% RETURNS:
%  activation = f(x), where f = sigmoid function

activation = 1./(1 + exp(-x));

end

