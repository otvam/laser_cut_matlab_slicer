function fv = get_assemble(img_data, merge_data)
%GET_ASSEMBLE Transform 2d images into plates and 3d assembly.
%   fv = GET_ASSEMBLE(img_data, merge_data)
%   img_data - information for transformer the images to plates (cell)
%      img_data{i}.img - color image with the contour information (matrix)
%      img_data{i}.scale - size per pixel of the image (scalar)
%      img_data{i}.simplify_tol - angular tolerance for contour simplification (scalar)
%      img_data{i}.h_growth - growth rate of the mesh (scalar)
%      img_data{i}.h_min - minimal mesh element (scalar)
%      img_data{i}.h_max - maximal mesh element (scalar)
%      img_data{i}.dz - thickness of the plate (scalar)
%   merge_data - information merging the plates together (cell)
%      merge_data{i}.idx - index of the plate to be considered (scalar)
%      merge_data{i}.perm - array with the axis permutation for the triangulation (vector)
%      merge_data{i}.offset - array with the offsets/shift for the triangulation (vector)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%
%   1. Transform the images into contours and into plates.
%   2. Select, permute, and shift the plates.
%   3. Assemble and merge the plates.
%
%   See also GET_ASSEMBLE_PART, GET_ASSEMBLE_MERGE, PLOT_3D_ASSEMBLE.

%   Thomas Guillod.
%   2019 - BSD License.

% get the plates from the images
for i=1:length(img_data)
    fprintf('n_part =  %d\n', i)
    fv_part_cell{i} = get_assemble_part(img_data{i});
end

% assemble the plates together
fprintf('assemble\n')
for i=1:length(merge_data)
    fv_merge_cell{i} = get_assemble_merge(merge_data{i}, fv_part_cell);
end

% merge the assembly
fprintf('merge\n')
fv = triangulation_merge(fv_merge_cell);

% disp
fprintf('disp\n')
disp_fv(fv)

end

function disp_fv(fv)
%DISP_SLICE Display some information about the results.
%   DISP_SLICE(fv)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)

% size of the triangulation
size_x = max(fv.vertices(:,1))-min(fv.vertices(:,1));
size_y = max(fv.vertices(:,2))-min(fv.vertices(:,2));
size_z = max(fv.vertices(:,3))-min(fv.vertices(:,3));

% disp
fprintf('    vertices = %d\n', size(fv.vertices, 1));
fprintf('    faces = %d\n', size(fv.faces, 1));
fprintf('    bnd = %d\n', size(fv.bnd, 1));
fprintf('    size_x = %.3f\n', size_x);
fprintf('    size_y = %.3f\n', size_y);
fprintf('    size_z = %.3f\n', size_z);

end