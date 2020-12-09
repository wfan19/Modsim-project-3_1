function Pf = landing_position(N, nBounces, g, COR, V0, P0)

    N = N ./ norm(N);

    V = zeros(3, nBounces);
    Vnew = zeros(3, nBounces);
    Vperps = zeros(3, nBounces);
    P = zeros(3, nBounces);

    V(:, 1) = V0;
    P(:, 1) = P0;


    nBounces = nBounces + 1; % actually, the number of bounces is one less than this number
    for bnc = 2:nBounces

        % discriminant = sqrt(V(bnc - 1) ^ 2 + 2 * N(3) * g * (P(:, bnc - 1).' * N'))
        t = (-V(:, bnc - 1).' * N - sqrt((V(:, bnc - 1).' * N)^2 + 2 * N(3) * g * (P(:, bnc - 1).' * N))) / -(N(3) * g);

        P(:, bnc) = P(:, bnc - 1) + V(:, bnc - 1) * t + [0; 0; -1/2 * g] * t^2;

        Vnew(:, bnc - 1) = V(:, bnc - 1) + [0; 0; -g] * t;

        Vperp = dot(Vnew(:, bnc - 1), N) * N;
        Vperps(:, bnc) = Vperp;


        V(:, bnc) = Vnew(:, bnc - 1) - Vperp * (1 + COR);
    end
    Pf = P(:, end);
end