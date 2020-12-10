function bounce_animation(T, States, Normals, Targets, save)
x = [-10, 10];
y = [-10, 10];
[X, Y] = meshgrid(x, y);

surf_plane = @(N, X, Y) (-N(1)/N(3) * X - N(2)/N(3) * Y);

unique_normals = unique(Normals, 'rows');
surf_tables = zeros(2, 2, length(unique_normals));
for i = 1 : size(unique_normals, 1)
    surf_tables(:, :, i) = surf_plane(unique_normals(i, :), X, Y);
end
min_tables = min(surf_tables, [], 'all');
max_tables = max(surf_tables, [], 'all');

Xbounds = [min(min(States(:, 1)), Targets(1)), max(max(States(:, 1)), Targets(1))];
Ybounds = [min(min(States(:, 2)), Targets(2)), max(max(States(:, 2)), Targets(2))];
Zbounds = [min(min(States(:, 3)), min_tables), max(max(States(:, 3)), max_tables)]; 

fig = figure();

for i = 1 : length(T)
    current_normal = Normals(i, :);
    
    clf
    hold on;
    if length(Targets) > 1
        v_target = Targets(i, 1:2);
    else
        v_target = Targets;
    end
    v_target(3) = surf_plane(current_normal, v_target(1), v_target(2));
    plot3(v_target(1), v_target(2), v_target(3), 'go'); 
    plot3(States(i, 1), States(i, 2), States(i, 3), 'ro');
    
    [X, Y] = meshgrid(Xbounds, Ybounds);
    surf_table = surf_plane(Normals(i, :), X, Y);
    mesh(X, Y, surf_table, 'EdgeColor', 'k');
    
    xlim(Xbounds);
    ylim(Ybounds);
    zlim(Zbounds);
    view(20, 10);
    title('Bouncing ball simulation')
    grid on;
    
    if save
        frame = getframe(fig);
        if i == 1
            pos = get(fig, 'Position');
            width = pos(3);
            height = pos(4);

            % Preallocate data (for storing frame data)
            mov = zeros(height, width, 1, length(T), 'uint8');
            [mov(:,:,1,i), map] = rgb2ind(frame.cdata, 256, 'nodither');
        else
            mov(:,:,1,i) = rgb2ind(frame.cdata, map, 'nodither');
        end
    else
        drawnow
    end
end

% Create animated GIF
if save
    imwrite(mov, map, 'animation.gif', 'DelayTime', 0, 'LoopCount', inf)
close(fig)
end