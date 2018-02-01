%%% PROBLEM 4 %%%

% (3) Make chains of associations. That is, store vectors f->g,
%  g->h, h->i, i->j, etc. Observe how noise increases if we start off
%  with f and cycle output back through the system.

dim = 10000; % Tested also 2, 100, 500, 1000, 5000, 10000

f = [];
for n = 1:dim
    fi = randn(1000, 1);
    finorm = fi / norm(fi);
    f(:,n) = finorm;
end

A = zeros(1000, 1000);
for n = 1:dim-1
    ft = transpose(f(:,n));
    ai = f(:,n+1) * ft;
    A = A + ai;
end

fprime = [];
compare = [];
lengths = [];
for n = 1:dim-1
    fiprime = A * f(:,n);
    fprime(:,n) = fiprime;
    compare = [compare ; dot(fprime(:,n), f(:,n+1))];
    lengths = [lengths ; norm(fiprime)];
end

fprintf('Chain noise:\n---- Links: %d, Avg. cosine: %12f, Avg. length: %12f\n', dim, mean(compare), mean(lengths));

% "Across the chain" noise:
% ---- Links: 2, Avg. cosine:     1.000000, Avg. length:     1.000000
% ---- Links: 100, Avg. cosine:     0.998835, Avg. length:     1.047121
% ---- Links: 500, Avg. cosine:     0.998816, Avg. length:     1.222304
% ---- Links: 1000, Avg. cosine:     0.998221, Avg. length:     1.410836
% ---- Links: 5000, Avg. cosine:     1.001326, Avg. length:     2.449740
% ---- Links: 10000, Avg. cosine:     1.001701, Avg. length:     3.318995

starting_input = f(:,1);
ending_output = f(:,1);
for n = 1:dim-1
    input_prime = A * f(:,n);
    ending_output = input_prime;
end
fprintf('---- Links: %d, Starting input len: %12f, Ending output len: %12f', dim, norm(starting_input), norm(ending_output));

% "Along the chain" noise:
% ---- Links: 2, Starting input len:     1.000000, Ending output len:     1.000000
% ---- Links: 100, Starting input len:     1.000000, Ending output len:     1.054125
% ---- Links: 500, Starting input len:     1.000000, Ending output len:     1.191063
% ---- Links: 1000, Starting input len:     1.000000, Ending output len:     1.391191
% ---- Links: 5000, Starting input len:     1.000000, Ending output len:     2.310085
% ---- Links: 10000, Starting input len:     1.000000, Ending output len:     3.361650
