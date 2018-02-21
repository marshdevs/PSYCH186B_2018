function neurons = ratio_layer( network, input, epsilon, iterations )
% RATIO LAYER
%
%
current_state = network;
input = double(input);

if input < 0
    neurons = current_state;
    return;
end

murds_constants = [1.0, 1.278, 1.556, 1.834, 2.112, 2.390, 2.668, 2.946, 3.224, 3.5];
relative_inputs = compute_distance(murds_constants, input);
for i = 1:10
    relative_inputs(i) = relative_inputs(i)*5;
end

new_state = zeros(1,10);

for i = 1:iterations
    for j = 1:10
        new_state(j) = current_state(j) + epsilon*(-relative_inputs(j) + network(j) - current_state(j));
    end
    new_state(find(new_state < 0)) = 0;
    current_state = new_state;
end

neurons = current_state;
