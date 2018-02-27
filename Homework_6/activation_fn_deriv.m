function [ activation ] = activation_fn_deriv( x )
% FUNCTION: Derivative of the sigmoid function
% PARAMS:
%  x = input vector
% RETURNS:
%  activation = f'(x), where f = sigmoid function

activation = exp(x)./(exp(x) + 1).^2;
end

