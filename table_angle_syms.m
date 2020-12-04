P_i = [5; 100];
v_i_0 = [-2; 0];

g = 9.8; % m/s/s
COR = 0.95;

syms h v_i d N v_f;

eqn1 = v_i == [v_i_0(1); sqrt(v_i_0(2)^2 + 2 * g * (P_i(2) + h))];

eqn2 = d == P_i(1) - v_i_0(1) * (v_i(2) - v_i_0(2)) / g;

eqn3 = N == [h; d] ./ norm([h; d]);

eqn4 = v_f == v_i - (v_i.' * N) * N * (1 + COR);

eqn5 = d == (3 * v_f(2) - sqrt(v_f(2)^2 + 2 * g * h)) / (2 * g) * v_f(1);

h_soln = solve([eqn1, eqn2, eqn3, eqn4, eqn5], [h, v_i, d, N, v_f])
