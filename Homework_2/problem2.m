%%% PROBLEM 2 %%%

% System from problem 1
dim = 1000;
f = randn(dim, 1);
g = randn(dim, 1);
fnorm = f / norm(f);
gnorm = g / norm(g);
ft = transpose(fnorm);
A = gnorm * ft;
gprime = A * fnorm;
dir_diff = dot(gprime,gnorm);

% (1) Generate a new normalized random vector, f'.
f2 = randn(1000, 1);
f2norm = f2 / norm(f2);

% (2) Check to see if it is more or less orthogonal to f by looking at the
%  cosine of the angle between f and f'
ortho_check = dot(f2norm,fnorm);
fprintf('orthogonality: %12f\n', ortho_check);

% (3) Compute Af' and look at the length of this vector
%  What do you think it should be? What is it?
%  length Af2 should = 0(f2 * f1), on average should be zero
f2prime = A * f2norm;
fprintf('length afprime: %12f', norm(f2prime));
