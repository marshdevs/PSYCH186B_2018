function output = origin_output( network )
%
%
%

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
ortho = randn(1, 10);
for i = 1:20
    network = archival_intelligence(f_training_set(i,:));
    network = network - dot(network, ortho) * ortho;
    network = network/norm(network);
    f_network_output = [f_network_output; network];
end


g_training_set = [
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    1, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 1, 0, 0, 0, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 1, 0, 0, 0;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1;
    0, 0, 0, 0, 0, 0, 0, 0, 0, 1
];

A = zeros(10, 10);
for i = 1:20
    ft = transpose(f_network_output(i,:));
    ai = ft * g_training_set(i,:);
    A = A + ai;
end

input = {'Cinnamon',6.5,1055.0,'Light Gray',1.7};

network = archival_intelligence(input);
network = network - dot(network, ortho) * ortho;
network = network/norm(network);
gprime = network * A;

for i = 1:20
    compare = dot(gprime, g_training_set(i,:));
    fprintf('Input compared to training data %d: %2f\n', i, compare);
end
