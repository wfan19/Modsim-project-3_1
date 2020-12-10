function bounce_animation_view(States, Normals, target)
x = [-10, 10];
y = [-10, 10];
[X, Y] = meshgrid(x, y);

surf_plane = @(N, X, Y) (-N(1)/N(3) * X - N(2)/N(3) * Y);

unique_normals = unique(Normals, 'rows');
surf_tables = zeros(2, 2, length(unique_normals));
for i = 1 : length(unique_normals)
    surf_tables(:, :, i) = surf_plane(unique_normals(i, :), X, Y);
end
min_tables = min(surf_tables, [], 'all');
max_tables = max(surf_tables, [], 'all');

Xbounds = [min(min(States(:, 1)), target(1)), max(max(States(:, 1)), target(1))];
Ybounds = [min(min(States(:, 2)), target(2)), max(max(States(:, 2)), target(2))];
Zbounds = [min(min(States(:, 3)), min_tables), max(max(States(:, 3)), max_tables)]; 

figure()
plot3(target(1), target(2), 0, 'bo');
for i = 1 : size(Normals, 1)
    clf
    hold on;
    %plot3(States(1:i, 1), States(1:i, 2), States(1:i, 3));
    plot3(States(i, 1), States(i, 2), States(i, 3), 'ro');
    
    [X, Y] = meshgrid(Xbounds, Ybounds);
    surf_table = surf_plane(Normals(i, :), X, Y);
    mesh(X, Y, surf_table);
    
    xlim(Xbounds);
    ylim(Ybounds);
    zlim(Zbounds);
    view(10, 5);
    grid on;
    
    drawnow
end
end