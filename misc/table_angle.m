P_i = [5; 100];
v_i_0 = [-2; 0];

g = 9.8; % m/s/s
COR = 0.95;

h = 1;

% syms h; % we will be solving for this

v_i = [v_i_0(1); sqrt(v_i_0(2)^2 + 2 * g * (P_i(2) + h))];

d = P_i(1) - v_i_0(1) * (v_i(2) - v_i_0(2)) / g

N = [h; d];
N = N ./ norm(N);

v_perp = (v_i.' * N) * N;
v_f = v_i - v_perp * (1 + COR);

d2 = (3 * v_f(2) - sqrt(v_f(2)^2 + 2 * g * h)) / (2 * g) * v_f(1)
