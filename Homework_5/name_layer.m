function neurons = name_layer( network, input, epsilon, iterations )
% NAME LAYER
%
%
current_state = network;
input = double(input);

if input < 0
    neurons = current_state;
    return;
end

murds_constants = {'A2231', 'E9091', 'Daisy', 'Gardenia', 'Cinnamon', 'Lorif', 'Rallev', 'Grotz', 'Tribok', 'Glorek'};
relative_inputs = compute_string_distance(murds_constants, input);
for i = 1:10
    relative_inputs(i) = relative_inputs(i)/1000;
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
