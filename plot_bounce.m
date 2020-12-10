function plot_bounce(States, p_0, Normals, bounceTimes)
    % Force bounceTimes to be a column
    bounceTimes = bounceTimes(:);
    uniqueNormals = unique(Normals);

    if size(unique(Normals), 1) > 2
%         % Multiple real bounces. Plot table at each point of bounce
%         
%         for i = 1 : length(bounceTimes)
%             P_bounce = States(T == bounces(i, 1), 1:3);
%         end
        
    else
        % Single real bounce, stationary table case. Plot the whole table.
        hold on;

        plot3(0, 0, 0, 'go');
        plot3(p_0(1), p_0(2), p_0(3), 'ro');

        plot3(States(:, 1), States(:, 2), States(:, 3));
        view(100, 10);

        Xbounds = [min(min(States(:, 1)), 0), max(max(States(:, 1)), 0)];
        Ybounds = [min(min(States(:, 2)), 0), max(max(States(:, 2)), 0)];

        [X, Y] = meshgrid(Xbounds, Ybounds);
        Z = -Normals(1)/Normals(3) * X - Normals(2)/Normals(3) * Y;
        mesh(X, Y, Z);
        
        xlabel("X (m)")
        ylabel("Y (m)")
        zlabel("Z (m)")
        
        legend('Target', 'Initial position', 'Location',"southwest")

        grid on         
    end
end