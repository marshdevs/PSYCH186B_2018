function neurons = gigahz_layer( network, input, epsilon, iterations )
% GIGAHZ LAYER
%
%
current_state = network;
input = double(input);

if input < 0
    neurons = current_state;
    return;
end

gigahz_constants = [947.9, 961.044, 974.188, 987.333, 1000.477, 1013.622, 1026.766, 1039.911, 1053.055, 1066.2];
relative_inputs = compute_distance(gigahz_constants, input);
for i = 1:10
    relative_inputs(i) = relative_inputs(i)/5;
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
        new_state(j) = current_state(j) + epsilon*(-relative_inputs(j) + network(j) - current_state(j));
    end
    new_state(find(new_state < 0)) = 0;
    current_state = new_state;
end

neurons = current_state;