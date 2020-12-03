function [T_all, States_all, endTimes] = bounceSim(nBounces, timeout, StatesIn, COR, origin, normal, g)
% g = 9.8;                % m/s^2
% N = [0; 0; 1];          % normal vector to plane
% Origin = [0; 0; 0];     % displacement of plane from origin

% Test comment

options = odeset('Events', @event_func, 'MaxStep', 0.01);

% initialize arrays
T_all = [];
States_all = [];
endTimes = zeros(1, nBounces);

% run a separate ode45 call for each bounce
for bnc = 1 : nBounces
    [T, StatesOut, ~, ~, event] = ode45(@rate_func, [0, timeout], StatesIn, options);
    % event tells us whether an event was triggered or ode45 timed out

    % store the results in the output vectors
    T_all = [T_all; T + endTimes(end)];
    States_all = [States_all; StatesOut];
    endTimes(bnc) = T_all(end);

    % if ode45 timed out, then the ball never hit the table, and we quit
    if isempty(event)
        break;
    end
    
    % otherwise, prepare for the next iteration of ode45
    % find the new initial velocity, and keep the position the same
    StatesIn = StatesOut(end, :);

    v_init = StatesIn(4:6).';
    v_perp = (v_init.' * normal) / norm(normal) ^ 2 * normal;
    v_final = v_init - v_perp * (1 + COR);

    StatesIn(4:6) = v_final; % the new initial velocity
end

    function [rates] = rate_func(~, States)
        %   States:
        % 1   X position (x)
        % 2   Y position (y)
        % 3   Z position (z)
        % 4   X velocity (xdot)
        % 5   Y velocity (ydot)
        % 6   Z velocity (zdot)

        xdot = States(4);
        ydot = States(5);
        zdot = States(6);

        xddot = 0;
        yddot = 0;
        zddot = -g;

        rates = [xdot; ydot; zdot; xddot; yddot; zddot];
    end

    function [value, isterminal, direction] = event_func(~, States)
        P = States(1:3);
        value = (P - origin).' * normal;
        isterminal = 1;
        direction = -1;
    end

end
