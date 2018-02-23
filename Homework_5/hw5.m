%%% Homework 5 %%%

training_data = {'Grotz', 6.9, 1006.4, 'Black', 3.5;
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

% test_data = {
%     '______', 7.3, '_____',  'Light Gray', 2.1;
%  '_____', 6.6, 1065.0, 'White', 2.1;
%  'Lil___', 6.7, 1045.0, 'White', '___';
%  '______', '___', 1065.0, 'Light Color', '___';
%  'Pl__ik', 7.0, 1006.3, 'Dark Color', '___';
%  '______', 7.3, 951.4, 'Green', 1.9;
%  'Krotork', 7.0, 1001.8, 'Light Gray', 1.0;
%  'Woshif', '___', 971.7, 'Blue', 1.7;
%  'Kritop', 7.2, '____', 'Dark Gray', 2.9;
%  'C06__', 6.7, '______', 'Orange', '___';
%  '_____', '___', '____', 'Black', 2.6;
%  'G__rk', 6.9, '>1000', 'Black or Dk Blue', 3.2;
%  '_9e__', 6.6, '______', 'Light Blue', 1.2;
%  '_6___', 6.6, '______', 'Orange', '___';
%  'Rash__', '___', 955.8, 'Light Blue', '___';
%  'Sor___', 7.4, '<1000', '_______________', '___';
%  'A____', 6.8, 1013.3, 'Light Color', 1.0;
%  'E4511', '___', '______', '_______________', '___';
%  '______', '___', '>1000', 'Light Color', 1.7;
%  'Mor___', 6.4 1055.0, '_______________', '___';
% };

test_data = {
    '', 7.3, 1000,  'Light Gray', 2.1;
 '', 6.6, 1065.0, 'White', 2.1;
 'Lil___', 6.7, 1045.0, 'White', 2.5;
 '', 6.9, 1065.0, 'Light Color', 2.5;
 'Pl__ik', 7.0, 1006.3, 'Dark Color', 2.5;
 '______', 7.3, 951.4, 'Green', 1.9;
 'Krotork', 7.0, 1001.8, 'Light Gray', 1.0;
 'Woshif', 6.9, 971.7, 'Blue', 1.7;
 'Kritop', 7.2, 1000, 'Dark Gray', 2.9;
 'C06__', 6.7, 1000, 'Orange', 2.5;
 '', 6.9, 1000, 'Black', 2.6;
 'G__rk', 6.9, 1050, 'Black or Dk Blue', 3.2;
 '_9e__', 6.6, 1000, 'Light Blue', 1.2;
 '_6___', 6.6, 1000, 'Orange', 2.5;
 'Rash__', 6.9, 955.8, 'Light Blue', 2.5;
 'Sor___', 7.4, 950, '', 2.5;
 'A____', 6.8, 1013.3, 'Light Color', 1.0;
 'E4511', 6.9, 1000, '', 2.5;
 '', 6.9, 1050, 'Light Color', 1.7;
 'Mor___', 6.4 1055.0, '', 2.5;
};

trials = [];
results = [];
for i = 1:20
    input = training_data(i,:);
    index = origin_output(input);

    if index < 6
        fprintf('Ship is Klingon: Hostility advised! (A = Hostile)\n');
        if i < 6
            results = [results, 1];
        else
            results = [results, 0];
        end
    elseif index < 11
        fprintf('Ship is Romulan: Stay on alert! (A = Alert)\n');
        if i < 11  && i > 5
            results = [results, 1];
        else
            results = [results, 0];
        end
    elseif index < 16
        fprintf('Ship is Antarean: Stand down! (A = Friendly)\n');
        if i > 10
            results = [results, 1];
        else
            results = [results, 0];
        end
    else
        fprintf('Ship is Federation: Stand down! (A = Friendly)\n');
        if i > 10
            results = [results, 1];
        else
            results = [results, 0];
        end
    end
    trials = [trials, i];
end

for i = 1:20
    input = test_data(i,:);
    index = origin_output(input);

    if index < 6
        fprintf('Ship is Klingon: Hostility advised! (A = Hostile)\n');
        if i == 5 || i == 7 || i == 9 || i == 11 || i == 12
            results = [results, 1];
        else
            results = [results, 0];
        end
    elseif index < 11
        fprintf('Ship is Romulan: Stay on alert! (A = Alert)\n');
        if i == 1 || i == 6 || i == 8 || i == 15 || i == 16
            results = [results, 1];
        else
            results = [results, 0];
        end
    elseif index < 16
        fprintf('Ship is Antarean: Stand down! (A = Friendly)\n');
        if i == 10 || i == 13 || i == 14 || i == 17 || i == 18 || i == 2 || i == 3 || i == 4 || i == 19 || i == 20
            results = [results, 1];
        else
            results = [results, 0];
        end
    else
        fprintf('Ship is Federation: Stand down! (A = Friendly)\n');
        if i == 10 || i == 13 || i == 14 || i == 17 || i == 18 || i == 2 || i == 3 || i == 4 || i == 19 || i == 20
            results = [results, 1];
        else
            results = [results, 0];
        end
    end
    trials = [trials, i+20];
end

plot(trials, results);
