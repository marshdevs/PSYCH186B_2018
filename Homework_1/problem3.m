dim = 2000; %10, 20, 50, 100, 250, 500, 1000, 2000
v1 = randn(dim, 50000);
v2 = randn(dim, 50000);
d = dot(v1, v2);

histogram(d)
fprintf('mean: %12f, stdev: %12f', mean(d), std(d));

% 10 mean:    -0.030312, stdev:     3.185221
% 20 mean:     0.003293, stdev:     4.443287
% 50 mean:     0.013764, stdev:     7.078484
% 100 mean:    -0.016419, stdev:     9.979615
% 250 mean:    -0.008430, stdev:    15.793571
% 500 mean:     0.031750, stdev:    22.400060
% 1000 mean:     0.147033, stdev:    31.546584
% 2000 mean:     0.538257, stdev:    44.786477
