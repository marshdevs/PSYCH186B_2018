function distances = compute_distance( constants, input)
% Compute the distances between the input value and the provided constants
distances = [];
for i = 1:10
    distance = abs(input - constants(i));
    distances = [distances , distance];
end
