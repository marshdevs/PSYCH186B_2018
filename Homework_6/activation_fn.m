function [ activation ] = activation_fn( x )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
activation = 1./(1 + exp(-x));

end

