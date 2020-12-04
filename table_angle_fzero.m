function N = table_angle_fzero(pos_toss, v_toss)

%     P_i = [5; 100];
%     v_i_0 = [-3; 0];

    g = 9.8; % m/s/s
    COR = 0.95;

    d = 0;
    N = [0; 0];

    h = fzero(@d_from_h, 0)
    d

    function error = d_from_h(h)

        x = 1;
        y = 2; % to make indexing clearer

        v_impact = [v_toss(x); -sqrt(v_toss(y)^2 + 2 * g * (pos_toss(y) - h))];
        % horz component unchanged; vf^2 = vi^2 + 2a(delta x)
        % delta x is the difference between the original height and h

        d1 = pos_toss(x) + v_toss(x) * (v_impact(y) - v_toss(y)) / -g;
        % x = x0 + v*t              and t = (vf - vi) / a
        % distance from origin at the time the ball is at height 0 + h

        N = [-h; d1];
        N = N ./ norm(N);

        v_perp = (v_impact.' * N) * N;
        v_rebound = v_impact - v_perp * (1 + COR);
        % velocity at the moment after impact
        N2 = N;

        t_full_parabola = 2 * v_rebound(y) / g; % two times because up and down trajectories are symmetric
        t_up_to_h = (-v_rebound(y) + sqrt(v_rebound(y)^2 - 2 * g * h)) / (2 * g);
        % from the quadratic formula where delta x = vi t + 1/2 at^2
        %                                  1/2 at^2 + vi t - delta x = 0

        d2 = (t_full_parabola - t_up_to_h) * v_rebound(x);
        % distance the ball will travel towards the origin on rebound
        % we want to find the table angle at which this value is equal to the actual distance from the origin.

        error = d1 - d2;
        d = d1; % store value for reference outside of the function
    end
end