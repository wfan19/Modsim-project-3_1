nBounces = 3; % actually, the number of bounces is one less than this number

N = [1; 1; 1];
g = 9.80;
COR = 0.95;

V = zeros(3, nBounces);
P = zeros(3, nBounces);

V(:, 1) = [2; -2; 2];
P(:, 1) = [10; 10; 10];

for bnc = 2:nBounces

    Vperp = V(:, bnc - 1).' * N / norm(N) ^ 2 * N;
    V(:, bnc) = V(:, bnc - 1) - Vperp * (1 + COR);

    t = (V(:, bnc).' * N - sqrt((V(:, bnc).' * N)^2 + 2 + N(3) * g * (P(:, bnc - 1).' * N))) / (N(3) * g);

    P(:, bnc) = P(:, bnc - 1) + V(:, bnc) * t;
end