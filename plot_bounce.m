function plot_bounce(States, p_0, Normals, T, bounceTimes)

% Force bounceTimes to be a column
bounceTimes = bounceTimes(:);
uniqueNormals = unique(Normals);

hold on;

plot3(0, 0, 0, 'go');
plot3(p_0(1), p_0(2), p_0(3), 'ro');

plot3(States(:, 1), States(:, 2), States(:, 3));
view(100, 10);

if size(uniqueNormals, 1) > 2
    % Multiple real bounces. Plot surface at each point of bounce
    func_surface = @(N, X, Y) (-N(1)/N(3) * X - N(2)/N(3) * Y);
    
    for i = 1 : length(bounceTimes)
        % P = Current ball position
        % N = Normal vector of surface
        % subscript _cb is short for current-bounce
        P_cb = States(T == bounceTimes(i), 1:3); % Search for bounce positions
        N_cb = Normals(T == bounceTimes(i), :); % Search for normal vectors
        
        x_range = max(States(:, 1)) - min(States(:, 1));
        y_range = max(States(:, 2)) - min(States(:, 2));
        
        scale = 0.08;
        xbounds_cb = P_cb(1) + x_range * scale * [-1, 1];
        ybounds_cb = P_cb(2) + y_range * scale * [-1, 1];
        
        [X_cb, Y_cb] = ...
            meshgrid(xbounds_cb, ybounds_cb);
        
        surf_cb = func_surface(N_cb, X_cb, Y_cb);
        mesh(X_cb, Y_cb, surf_cb)
    end
else
    % Single real bounce, stationary table case. Plot the whole table.
    Xbounds = [min(min(States(:, 1)), 0), max(max(States(:, 1)), 0)];
    Ybounds = [min(min(States(:, 2)), 0), max(max(States(:, 2)), 0)];

    [X, Y] = meshgrid(Xbounds, Ybounds);
    Z = -Normals(1, 1)/Normals(1, 3) * X - Normals(1, 2)/Normals(1, 3) * Y;
    mesh(X, Y, Z);       
end

xlabel("X (m)")
ylabel("Y (m)")
zlabel("Z (m)")

legend('Target', 'Initial position', 'Location',"southwest")

grid on;

end