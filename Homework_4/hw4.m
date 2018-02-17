%%% Homework 4 %%%

% Initial parameters
max_inhibition = 2.0;
length_constant = 2;
neurons = 80;
iterations = 50;
T = 50;
minfirerate = 0;
maxfirerate = 100;
epsilon = 1/500;

% Generate Initial State Vector (simple lateral inhibition)
initial_state_vector = [];
for i = 1:neurons/4
    initial_state_vector  = [initial_state_vector; 10];
end
for i = i+1:3*neurons/4
    initial_state_vector = [initial_state_vector; 40];
end
for i = i+1:neurons
    initial_state_vector = [initial_state_vector; 10];
end
current_state_vector = initial_state_vector;

% Generate Initial State Vector (winner take all network)
% initial_state_vector = [];
% for i = 1:neurons
%     if (i == 17 || i == 23)
% %         initial_state_vector = [initial_state_vector ; 20];
%         initial_state_vector = [initial_state_vector ; 10];
%     elseif (i == 18 || i == 22 || i == 14 || i == 16)
%         initial_state_vector = [initial_state_vector ; 20];
%     elseif (i == 19 || i == 21 || i == 15)
%         initial_state_vector = [initial_state_vector ; 30];
%     elseif i == 20
%         initial_state_vector = [initial_state_vector ; 40];
%     else
%         initial_state_vector = [initial_state_vector ; 10];
%     end
% end
% current_state_vector = initial_state_vector;

% Make Inhibitory Weights
% - Make first vector
distances = [];
i  = 1;
for j = 1:neurons
    distance = abs(i - j);
    distances = [distances ; distance];
end

wrapindex = find(distances>(neurons/2));
distances(wrapindex) = neurons - distances(wrapindex);
for i = 1:neurons
    distances(i) = -max_inhibition * exp(-distances(i)/length_constant);
end
distances(1) = 0;

% Make New State Vector
new_state_vector = zeros(neurons, 1);
for i = 1:iterations
    for j = 1:neurons
        weight_vector = inhibitory_weight(distances, j);
        new_state_vector(j) = current_state_vector(j) + epsilon*(initial_state_vector(j) + dot(weight_vector, current_state_vector') - current_state_vector(j));
    end
    new_state_vector(find(new_state_vector < 0)) = minfirerate;
    new_state_vector(find(new_state_vector > maxfirerate)) = maxfirerate;
    current_state_vector = new_state_vector;
end

fprintf("%2f", current_state_vector);

% - function for j's inhibitory weight
function z = inhibitory_weight(weights, j)
    z = circshift(weights,j);
end

