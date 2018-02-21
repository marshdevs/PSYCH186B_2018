function neurons = murds_layer( network, input, epsilon, iterations )
% MURDS LAYER
%
%
current_state = network;
input = double(input);

if input < 0
    neurons = current_state;
    return;
end

murds_constants = [6.4, 6.511, 6.622, 6.733, 6.844, 6.955, 7.066, 7.177, 7.288, 7.399];
relative_inputs = compute_distance(murds_constants, input);
for i = 1:10
    relative_inputs(i) = 1/(relative_inputs(i) + .001);
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
