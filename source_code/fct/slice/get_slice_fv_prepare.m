function fv = get_slice_fv_prepare(fv, fv_data)
%GET_SLICE_FV_PREPARE Permute, scale, and translate the triangulation.
%   fv = GET_SLICE_FV_PREPARE(fv, fv_data)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   fv_data - information for the scaling of the 3d fv (struct)
%      fv_data.scale - scaling factor for the triangulation (scalar)
%      fv_data.perm - array with the axis permutation for the triangulation (vector)
%      fv_data.offset - array with the offsets/shift for the triangulation (vector)
%
%   See also GET_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

% extract
offset = fv_data.offset;
perm = fv_data.perm;
scale = fv_data.scale;

% permute, scale, and translate
fv = triangulation_permutation(fv, perm);
fv = triangulation_scale(fv, scale);
fv = triangulation_offset(fv, offset);

% size of the triangulation
size_x = max(fv.vertices(:,1))-min(fv.vertices(:,1));
size_y = max(fv.vertices(:,2))-min(fv.vertices(:,2));
size_z = max(fv.vertices(:,3))-min(fv.vertices(:,3));

% disp
fprintf('    vertices = %d\n', size(fv.vertices, 1));
fprintf('    faces = %d\n', size(fv.faces, 1));
fprintf('    size_x = %.3f\n', size_x);
fprintf('    size_y = %.3f\n', size_y);
fprintf('    size_z = %.3f\n', size_z);

end
