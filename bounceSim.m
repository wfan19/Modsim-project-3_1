function [T_all, States_all, Normals_all, endTimes] = bounceSim(nBounces, timeout, StatesIn, g, COR, origin, func_normal, target)
% g = 9.8;                % m/s^2
% N = [0; 0; 1];          % normal vector to plane
% Origin = [0; 0; 0];     % displacement of plane from origin

% Test comment

options = odeset('Events', @event_func, 'MaxStep', 0.01);

% initialize arrays
T_all = [];
States_all = [];
endTimes = zeros(1, nBounces);
Normals_all = [];

% run a separate ode45 call for each bounce
for bnc = 1 : nBounces
    % Before we "launch" the ball by starting the next simulation loop we
    % calculate the table angle we're going to use until after the next
    % bounce
    if size(target, 1) == nBounces
        current_normal = func_normal(StatesIn, target(bnc, :)); 
    else
        current_normal = func_normal(StatesIn, target(1, :)); 
    end
    
    tspan = linspace(0, timeout, timeout * 20);
    [T, StatesOut, ~, ~, event] = ode45(@rate_func, tspan, StatesIn, options);
    % event tells us whether an event was triggered or ode45 timed out

    % Fill in list of normal vector postions, now that we know the end time
    % and step count
    % The (:)' forces current_normal to be a row to follow ode45 syntax
    current_normals = repelem(current_normal(:)', length(T), 1);
    
    % store the results in the output vectors
    if bnc == 1
        T_all = T;
    else
        T_all = [T_all; T + endTimes(bnc - 1)];
    end
    
    States_all = [States_all; StatesOut];
    Normals_all = [Normals_all; current_normals];
    endTimes(bnc) = T_all(end);

    % if ode45 timed out, then the ball never hit the table, and we quit
    if isempty(event)
        break;
    end
    
    % otherwise, prepare for the next iteration of ode45
    % find the new initial velocity, and keep the position the same
    StatesIn = StatesOut(end, :);

    v_init = StatesIn(4:6).';
    v_perp = (v_init.' * current_normal) / norm(current_normal) ^ 2 * current_normal;
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
        table_z = -current_normal(1)/current_normal(3) * (P(1) - origin(1)) - current_normal(2)/current_normal(3) * (P(2) - origin(2));
        value =  P(3) - table_z;
        isterminal = 1;
        direction = -1;
    end

end
