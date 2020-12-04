function N = table_angle_fzero(pos_toss, v_toss)

%     P_i = [5; 100];
%     v_i_0 = [-3; 0];

    g = 9.8; % m/s/s
    COR = 0.95;

    d = 0;
    N = [0; 0];
    v_impact2 = [0; 0];


    h = fzero(@d_from_h, 0)
    d
    v_impact2

    function error = d_from_h(h)

        x = 1;
        y = 2; % to make indexing clearer


        t_before_impact = (-v_toss(y) - sqrt(v_toss(y)^2 - 4 * 1/2 * -g * -(-pos_toss(y) + h))) / (2 * 1/2 * -g);

        % velocity on (just before) impact
        % calculated two different ways
        v_impact_time_based = [0; 0];
        v_impact_time_based(x) = v_toss(x); % horizontal component unchanged
        v_impact_time_based(y) = v_toss(y) + -g * t_before_impact;

        v_impact = [0; 0];
        v_impact(x) = v_toss(x); % horizontal component unchanged
        v_impact(y) = -sqrt(v_toss(y)^2 + 2 * g * (pos_toss(y) - h));
        % vf^2 = vi^2 + 2a(delta x)
        % delta x is the difference between the original height and h

        assert(norm(v_impact_time_based - v_impact) < 0.001);
        v_impact2 = v_impact;

        % distance from origin at the time the ball is at height 0 + h
        d1 = pos_toss(x) + v_toss(x) * (v_impact(y) - v_toss(y)) / -g;
        % x = x0 + v*t      and t = (vf - vi) / a
        assert(abs((v_impact(y) - v_toss(y)) / -g - t_before_impact) < 0.0001);

        N = [-h; d1];
        N = N ./ norm(N);
        N2 = N;


        v_perp = (v_impact.' * N) * N;
        v_rebound = v_impact - v_perp * (1 + COR);
        % velocity at the moment after impact

        % time spent in the air after bouncing
        t_full_parabola = 2 * (0 - v_rebound(y) / -g); % two times because up and down trajectories are symmetric
        t_up_to_h = (-v_rebound(y) - sqrt(v_rebound(y)^2 - 2 * -g * -h)) / (2 * -g);
        %       t = (-vi         +/- sqrt(     vi^2    - 4(1/2) a -delta x)) / 2a)
        % from the quadratic formula where delta x = vi t + 1/2 at^2
        %       1/2 at^2 + vi t - delta x = 0

        % distance the ball will travel towards the origin on rebound
        d2 = (t_full_parabola - t_up_to_h) * -v_rebound(x) * 2;
        % we want to find the table angle at which this value is equal to the actual distance from the origin.

        error = d1 - d2;
        d = d1; % store value for reference outside of the function
    end
end