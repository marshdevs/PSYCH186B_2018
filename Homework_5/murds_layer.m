function neurons = murds_layer( network, input, epsilon, iterations )
% MURDS LAYER
%
%
current_state = network;
input = double(input);

murds_constants = [6.4, 6.511, 6.622, 6.733, 6.844, 6.955, 7.066, 7.177, 7.288, 7.399];
relative_inputs = compute_distance(murds_constants, input);
for i = 1:10
    relative_inputs(i) = 1/relative_inputs(i);
end

distances = [];
for i = 1:10
    distance_row = [];
    for j = 1:10
        distance = abs(i-j);
%         distance = 0;
        distance_row = [distance_row, distance];
    end
    distances = [distances; distance_row];
end
distances = -0.1*exp(-distances/2);

for i = 1:10
    for j = 1:10
        if (i == j)
            distances(i,j) = 0;
        end
    end
end

new_state = zeros(1,10);

for i = 1:iterations
    for j = 1:10
        new_state(j) = current_state(j) + epsilon*(relative_inputs(j) + network(j) + dot(distances(j,:), current_state) - current_state(j));
    end
    new_state(find(new_state < 0)) = 0;
    current_state = new_state;
end

neurons = network;
