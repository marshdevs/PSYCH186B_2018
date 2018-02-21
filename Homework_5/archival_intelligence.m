%%% Homework 5 - Archival Intelligence %%%
function network = archival_intelligence( input )
network = [100 100 100 100 100 100 100 100 100 100];

input = serialize_data(input, 1, 5);

epsilon = 1/100;
iterations = 50;

%%% Name Layer %%%
network = name_layer(network, input{1,1}, epsilon, iterations);

%%% Warp Drive Layer %%%
network = murds_layer(network, input{1,2}, epsilon, iterations);

%%% Hailing Transponder Layer %%%
network = gigahz_layer(network, input{1,3}, epsilon, iterations);

%%% Surface Reflect Layer %%%
network = color_layer(network, input{1,4}, epsilon, iterations);

%%% Axis Ratio Layer %%%
network = ratio_layer(network, input{1,5}, epsilon, iterations);

