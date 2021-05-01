function [fv, cut] = get_slice(fv, fv_data, cut_data)
%GET_SLICE Slice a 3d triangulation with different planes.
%   [fv, cut] = GET_SLICE(fv, fv_data, cut_data)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   fv_data - information for the scaling of the 3d fv (struct)
%      fv_data.scale - scaling factor for the triangulation (scalar)
%      fv_data.perm - array with the axis permutation for the triangulation (vector)
%      fv_data.offset - array with the offsets/shift for the triangulation (vector)
%   cut_data - information for slicing the 3d fv (cell)
%      cut_data{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut_data{i}.value - coordinate of the cut along the specified axis (scalar)
%      cut_data{i}.value - coordinate of the cut along the specified axis (scalar)
%      cut_data{i}.thr - thresold for connecting points (scalar)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines (matrix)
%
%   1. Permute, scale, and translate the triangulation.
%   2. Slice the object and extract the cut lines.
%
%   See also GET_SLICE_FV_PREPARE, GET_SLICE_CUT, PLOT_2D_SLICE, PLOT_3D_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

% prepate the triangulation
fprintf('prepare\n')
fv = get_slice_fv_prepare(fv, fv_data);

% slice the triangulation
for i=1:length(cut_data)
    fprintf('n_slice =  %d\n', i)
    cut{i} = get_slice_cut(fv, cut_data{i});
end

% disp
fprintf('disp\n')
disp_slice(fv, cut)

end

function disp_slice(fv, cut)
%DISP_SLICE Display some information about the results.
%   DISP_SLICE(fv, cut)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines ('x', 'y', 'z') (matrix)

% size of the triangulation
size_x = max(fv.vertices(:,1))-min(fv.vertices(:,1));
size_y = max(fv.vertices(:,2))-min(fv.vertices(:,2));
size_z = max(fv.vertices(:,3))-min(fv.vertices(:,3));

% disp
fprintf('    cut = %d\n', length(cut));
fprintf('    vertices = %d\n', size(fv.vertices, 1));
fprintf('    faces = %d\n', size(fv.faces, 1));
fprintf('    size_x = %.3f\n', size_x);
fprintf('    size_y = %.3f\n', size_y);
fprintf('    size_z = %.3f\n', size_z);

end