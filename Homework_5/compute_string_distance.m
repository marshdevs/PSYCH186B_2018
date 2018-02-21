function distances = compute_string_distance( constants, input )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
constants = serialize_data(constants, 1, 10);

distances = [];
for i = 1:10
    len = length(constants{1, i});
    while len > length(input)
        input = [input, 0];
    end
    while len < length(input)
        dog = constants{1, i};
        dog = [dog, 0];
        constants{1, i} = dog;
        len = len + 1;
    end
    
    distance = dot(input, constants{1, i});
    distances = [distances, distance];

end

