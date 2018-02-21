%%% Homework 5 - Archival Intelligence %%%
network = [100 100 100 100 100 100 100 100 100 100];
input = ["______" 7.3  "_____" "Light Gray" 2.1];
epsilon = 1/100;
iterations = 50;

%%% Name Layer %%%
name_value = input(1);
network = name_layer(network, name_value, epsilon, iterations);

%%% Warp Drive Layer %%%
murds_value = input(2);
network = murds_layer(network, murds_value, epsilon, iterations);

%%% Hailing Transponder Layer %%%
gigahz_value = input(3);
network = gigahz_layer(network, gigahz_value, epsilon, iterations);

%%% Surface Reflect Layer %%%
color_value = input(4);
network = color_layer(network, color_value, epsilon, iterations);

%%% Axis Ratio Layer %%%
ratio_value = input(5);
network = ratio_layer(network, ratio_value, epsilon, iterations);
fprintf("%d,", network);

%%% Origin Output %%%
% network = origin_output(network);

%%% Req. Action Conclusion %%%
% conclusion = req_action(network);

% fprintf("Required action: %s", conclusion);
