function [v_path] = interp_normals(v_0, v_f, count)
% PARAMS:
% v_0: Starting direction vector. 3d. Column or row
% v_f: End direction vector. 3d. Column or row.
% count: Number of interpolated vectors desired. Scalar.

% Out:
% v_path: 'count by 3' row matrix where each row is an interpolated vector


% All orientations of vectors will be represented as a rotation from this
basis = [0; 0; 1];

% Force input vectors to be columns
v_0 = v_0(:);
v_f = v_f(:);

% Normalize input vectors
v_0 = v_0/norm(v_0);
v_f = v_f/norm(v_f);

% Represent orientation of vectors as a rotation matrix applied to [0 0 1]
rotm_n0= v_0 / basis;
rotm_nf= v_f / basis;

% Convert rotation matrix orientations into quaternions
quat_n0 = quaternion(rotm2quat(rotm_n0));
quat_nf = quaternion(rotm2quat(rotm_nf));

% Interpolation
% What we get through slerp is a list of quaternions representing rotations
% from the basis to the intermediate (interpreted) vectors
quat_path = slerp(quat_n0, quat_nf, linspace(0, 1, count));
v_path = rotatepoint(quat_path, basis');

end
