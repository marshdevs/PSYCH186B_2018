%%% PROBLEM 1 %%%

dim = 1000;
% (1) Generate two vectors, f & g
f = randn(dim, 1);
g = randn(dim, 1);

% (2) Set the mean of the vectors to 0
%  Since I generated them using randn(), which generates
%   random numbers from a normal distribution, the means of
%   f & g are already 0.
fprintf('mean f: %12f, mean g: %12f\n', mean(f), mean(g));

% (3) Normalize them
fnorm = f / norm(f);
gnorm = g / norm(g);
fprintf('length f: %12f, length g: %12f\n', norm(fnorm), norm(gnorm));

% (4) Compute A
ft = transpose(fnorm);
A = gnorm * ft;

% (5) Show that Af gives an output g' which is in the same
%  direction as g. 
%  Cos Theta = 1 rad means Theta = 0
gprime = A * fnorm;
dir_diff = dot(gprime,gnorm);
fprintf('cos angle between gprime and g (should be 1.00): %12f\n', dir_diff);
fprintf('length gprime: %12f\n', norm(gprime));
