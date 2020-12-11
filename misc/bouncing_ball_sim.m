function [T_all, States_all, ending_times] = bouncing_ball_sim(num_bounces, bounce_timeout, states0, coeff_restitution)
g = 9.8; % m/s^2

options = odeset('Events', @event_func, 'MaxStep', 0.01);

T_all = [];
States_all = [];

bounce_states0 = states0;
ending_times = zeros(1, num_bounces);

for i = 1 : num_bounces
    [T, States] = ode45(@rate_func,[0 bounce_timeout], bounce_states0, options); 
    
    T_all = [T_all; T + ending_times(end)];
    States_all = [States_all; States];

    ending_times(i) = T_all(end);

    bounce_states0 = States(end, :);
    bounce_states0(4) = coeff_restitution * abs(bounce_states0(4));
end

    % Y States:
    % X position (x)
    % X velocity (xdot)
    % Y position (y)
    % Y velocity (ydot)
    function [rates] = rate_func(~, States)
        xdot = States(2);
        xddot = 0;
        
        ydot = States(4);
        yddot = -g;
        
        rates = [xdot; xddot; ydot; yddot];
    end

    function [value, isterminal, direction] = event_func(~, States)
        
        value = States(3);
        isterminal = 1;
        direction = -1;
    end 

end