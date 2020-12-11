function Normals_out = interpolated_normals(Normals_in)
%     unique_normals = Normals_in;
    unique_normals = Normals_in(diff(Normals_in(:, 1)) ~= 0, :);

    normal_indices = 1:length(Normals_in(:, 1));
    normal_indices = normal_indices(diff(Normals_in(:, 1)) ~= 0);
    normal_indices(end + 1) = length(Normals_in);
    % unique_normals = unique(Normals_in, 'rows');

    Normals_out = Normals_in; % with some modifications, below

    if length(unique_normals) < 2
        return
    end

    for i = 2:length(unique_normals)

        len_indices = normal_indices(i + 1) - normal_indices(i);


        % carry over the normals from the previous bounce for one-third of the time
        carry_over_range = normal_indices(i): normal_indices(i) + round(len_indices * 1/3);
        Normals_out(carry_over_range, :) = repmat(unique_normals(i - 1, :), length(carry_over_range), 1);


        % then interpolate for the next one-third
        interp_range = carry_over_range + 1: normal_indices(i) + round(len_indices * 1/3);

        x_interp = linspace(unique_normals(i - 1, 1), unique_normals(i, 1), length(interp_range));
        y_interp = linspace(unique_normals(i - 1, 2), unique_normals(i, 2), length(interp_range));
        z_interp = linspace(unique_normals(i - 1, 3), unique_normals(i, 3), length(interp_range));

        Normals_out(interp_range.', :) = [x_interp.', y_interp.', z_interp.'];


        % and leave the last one-third the same

    end
end