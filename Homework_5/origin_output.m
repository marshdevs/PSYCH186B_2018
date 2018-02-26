function output = origin_output( input )
%
%
%

learning_trials = 100000;
epsilon = 1/1000;

f_training_set = {'Grotz', 6.9, 1006.4, 'Black', 3.5;
    'Tlarr',7.0,994.3,'Black',2.3;
    'Tribok',7.3,978.1,'Dark Gray',2.8;
    'Brogut',7.1,1005.4,'Dark Gray',3.0;
    'Glorek',7.1,1001.8,'Light Gray',1.0;
    'Lorif',7.3,980.4,'Dark Blue',1.6;
    'Rallev',7.4,977.2,'Dark Green',1.8;
    'Willosh',7.3,947.9,'Light Gray',1.9;
    'Loshar',7.2,955.8,'Light Blue',2.1;
    'Sarash',7.4,960.7,'Light Gray',2.3;
    'A2231',6.7,1010.9,'Pink',1.2;
    'E7763',6.8,1033.2,'Orange',1.2;
    'E9091',6.5,1025.4,'Light Blue',1.1;
    'A0199',6.8,1066.2,'Yellow',1.3;
    'A1091',6.7,1015.0,'Light Blue',1.0;
    'Daisy',6.7,1050.0,'White',1.9;
    'Rosehip',6.8,1055.0,'Light Gray',2.0;
    'Gardenia',6.5,1045.0,'White',2.1;
    'Herb',6.4,1065.0,'Light Gray',2.6;
    'Cinnamon',6.5,1055.0,'Light Gray',1.7
};
f_network_output = [];
for i = 1:20
    data = archival_intelligence(f_training_set(i,:));
    data = data/norm(data);
    f_network_output = [f_network_output; data];
end


g_training_set = [];
for i = 1:20
    g = zeros(1,50);
    if i < 6
        g(10) = 1;
    elseif i < 11
        g(20) = 1;
    elseif i < 16
        g(30) = 1;
    else
        g(40) = 1;
    end
    g_training_set = [g_training_set; g];
end
g_training_set = g_training_set/norm(g_training_set);        

% A = zeros(50, 50);
% for i = 1:20
%     ft = f_network_output(i,:);
%     ai = transpose(ft) * g_training_set(i,:);
%     A = A + ai;
% end
g_training_set = g_training_set';
f_network_output = f_network_output';
A = g_training_set * f_network_output';

for i = 1:learning_trials
    vi = floor(rand*20) + 1;
    ki = 1/(f_network_output(:,vi)' * f_network_output(:,vi)) - epsilon;
    gprime = A * f_network_output(:,vi);
    deltaA = ki*(g_training_set(:, vi) - gprime)*f_network_output(:,vi)';
    A = A + deltaA;
end

network = archival_intelligence(input);
network = network/norm(network);
network = network';
gprime = A * network;

compare = [];
for i = 1:20
    e = (g_training_set(:, i) - gprime)*(g_training_set(:, i) - gprime)';
    l = norm(e);
    compare = [compare, l];
end
[val, index] = min(compare);

output = index;
