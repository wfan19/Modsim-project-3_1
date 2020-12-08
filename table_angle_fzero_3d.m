function N = table_angle_fzero_3d(pos_toss, v_toss)

%     P_i = [5; 100];
%     v_i_0 = [-3; 0];

    g = 9.8; % m/s/s
    COR = 0.95;

    d = 0;
    N = [0; 0];
    v_impact2 = [0; 0];
    pos_impact = [0; 0; 0];
    plane_vec_1 = [0; 0; 0];
    plane_vec_2 = [0; 0; 0];
    vec_toss = [0; 0; 0];


    h = fzero(@d_from_h, 0)
    d
    v_impact2
    vec_toss
    quiver3(0, 0, 0, N(1) / norm(N) * 150, N(2) / norm(N) * 150, N(3) / norm(N) * 150, 'm');
    quiver3(pos_impact(1), pos_impact(2), pos_impact(3), pos_impact(1) + plane_vec_1(1) / norm(plane_vec_1) * 2, ...
        pos_impact(2) + plane_vec_1(2) / norm(plane_vec_1) * 2, pos_impact(3) + plane_vec_1(3) / norm(plane_vec_1) * 2, 'b');
    quiver3(pos_impact(1), pos_impact(2), pos_impact(3), pos_impact(1) + plane_vec_2(1) / norm(plane_vec_2) * 2, ...
        pos_impact(2) + plane_vec_2(2) / norm(plane_vec_2) * 2, pos_impact(3) + plane_vec_2(3) / norm(plane_vec_2) * 2, 'r');
    quiver3(pos_impact(1), pos_impact(2), pos_impact(3), vec_toss(1) / norm(vec_toss) * 100, ...
        vec_toss(2) / norm(vec_toss) * 100, vec_toss(3) / norm(vec_toss) * 100, 'g');
    quiver3(pos_impact(1), pos_impact(2), pos_impact(3), N(1) * 500, N(2) * 500, 0, 'y');

    function error = d_from_h(h)

        x = 1;
        y = 2;
        z = 3; % to make indexing clearer


        t_before_impact = (-v_toss(z) - sqrt(v_toss(z)^2 - 4 * 1/2 * -g * -(-pos_toss(z) + h))) / (2 * 1/2 * -g);

        % velocity on (just before) impact
        % calculated two different ways
        v_impact_time_based = [0; 0; 0];
        v_impact_time_based(x) = v_toss(x); % horizontal component unchanged
        v_impact_time_based(y) = v_toss(y); % horizontal component unchanged
        v_impact_time_based(z) = v_toss(z) + -g * t_before_impact;

        v_impact = [0; 0; 0];
        v_impact(x) = v_toss(x); % horizontal component unchanged
        v_impact(y) = v_toss(y); % horizontal component unchanged
        v_impact(z) = -sqrt(v_toss(z)^2 + 2 * g * (pos_toss(z) - h));
        % vf^2 = vi^2 + 2a(delta x)
        % delta x is the difference between the original height and h

        % assert(norm(v_impact_time_based - v_impact) < 0.001);
        v_impact2 = v_impact;

        % distance from origin at the time the ball is at height 0 + h
        r1 = [0; 0];
        r1(x) = pos_toss(x) + v_toss(x) * (v_impact(z) - v_toss(z)) / -g;
        r1(y) = pos_toss(y) + v_toss(y) * (v_impact(z) - v_toss(z)) / -g;
        % x = x0 + v*t      and t = (vf - vi) / a

        % assert(abs((v_impact(z) - v_toss(z)) / -g - t_before_impact) < 0.0001);

        pos_impact  = [r1(x); r1(y); h];
        origin = [0; 0; 0];

        plane_vec_1 = pos_impact - origin + [0; 0; -2 * h];

        vec_toss = pos_impact - pos_toss.';
%         vec_toss = vec_toss ./ norm(vec_toss);
        vec_impact = pos_impact - origin;
%         vec_impact = vec_impact ./ norm(vec_impact);
%{
%         plane_vec_2 = [0; 0; 0];
        plane_vec_2 = vec_toss + vec_impact;
        % plane_vec_2(z) = h;

        if norm(plane_vec_2) - norm(plane_vec_1) < 0.0001
            x0 = plane_vec_1(x);
            y0 = plane_vec_1(y);
            z0 = plane_vec_1(z); % = h
            plane_vec_2 = plane_vec_1 + [-y0; x0; 0];
        end
        N = cross(-plane_vec_1, plane_vec_2);
%}

        % projection = -(vec_toss(x:y) + vec_impact(x:y)) ./ COR; % [0, -1; 1, 0] *
        % aaa = vec_toss(x:y);
        bbb = pos_toss(x:y).' - origin(x:y); % vec_toss(x:y) + vec_impact(x:y);
        % projection = (aaa.' * bbb * bbb ./ norm(bbb) ^ 2) ./ COR; % [0, -1; 1, 0] *+ v
        projection = (-v_impact(x:y) + v_toss(x:y) ./ COR) * 2;
%{
        % v_b = vec_toss(x:y);
        v_b = [1; 0];
        theta = subspace(projection, v_b);
        Rotation = [cos(theta), -sin(theta), 0; sin(theta), cos(theta), 0; 0, 0, 1];
        N = Rotation * [-h; 0; norm(r1)];
%}
%
        if h == 0
            N = [0; 0; 1]; % almost never correct
        else
            N = [projection(x); projection(y); -1 / h];
        end
%}
        N = N ./ norm(N);
        if N(z) < 0
            N = -N;
        end
        N2 = N;


        v_perp = (v_impact.' * N) * N;
        v_rebound = v_impact - v_perp * (1 + COR);
        % velocity at the moment after impact

        % time spent in the air after bouncing
        t_full_parabola = 2 * (0 - v_rebound(z) / -g); % two times because up and down trajectories are symmetric
        t_up_to_h = (-v_rebound(z) + sqrt(v_rebound(z)^2 - 2 * -g * -h)) / (2 * -g);
        %       t = (-vi         +/- sqrt(     vi^2    - 4(1/2) a -delta x)) / 2a)
        % from the quadratic formula where delta x = vi t + 1/2 at^2
        %       1/2 at^2 + vi t - delta x = 0

        % distance the ball will travel towards the origin on rebound
        r2 = (t_full_parabola - t_up_to_h) * v_rebound(1:2) * 2;
        % we want to find the table angle at which this value is equal to the actual distance from the origin.

        error = norm(r1) - norm(r2); % min(norm(r1 - r2), norm(r1 + r2)); % in case of opposite directions
        if abs(error) < 1
            breakpoint = 0;
        end

        d = r1; % store value for reference outside of the function
    end
end