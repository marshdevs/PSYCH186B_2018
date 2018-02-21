function neurons = color_layer( network, input, epsilon, iterations )
% COLOR LAYER
%
%
current_state = network;
input = double(input);

if input < 0
    neurons = current_state;
    return;
end

murds_constants = [0, 1.11, 2.22, 3.33, 4.44, 5.55, 6.66, 7.77, 8.88, 10];
relative_inputs = compute_distance(murds_constants, input);

new_state = zeros(1,10);

for i = 1:iterations
    for j = 1:10
        new_state(j) = current_state(j) + epsilon*(-relative_inputs(j) + network(j) - current_state(j));
    end
    new_state(find(new_state < 0)) = 0;
    current_state = new_state;
end

neurons = current_state;