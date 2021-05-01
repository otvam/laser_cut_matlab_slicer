function fv = get_assemble_merge(merge_data, fv_part_cell)
%GET_ASSEMBLE_MERGE Transform 2d images into plates and 3d assembly.
%   fv = GET_ASSEMBLE_MERGE(merge_data, fv_part_cell)
%   merge_data - information merging the plates together (cell)
%      merge_data{i}.idx - index of the plate to be considered (scalar)
%      merge_data{i}.perm - array with the axis permutation for the triangulation (vector)
%      merge_data{i}.offset - array with the offsets/shift for the triangulation (vector)
%   fv_part_cell - triangulation content (cell)
%      fv_part_cell{i}.vertices - vertices matrix (matrix)
%      fv_part_cell{i}.faces - triangulation faces matrix (matrix)
%      fv_part_cell{i}.bnd - boundary edges matrix (matrix)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%
%   See also GET_ASSEMBLE.

%   Thomas Guillod.
%   2019 - BSD License.

% extract
offset = merge_data.offset;
perm = merge_data.perm;
idx = merge_data.idx;

% select the right plate
fv = fv_part_cell{idx};

% permute the axis
fv = triangulation_permutation(fv, perm);

% translate the plate
fv = triangulation_offset(fv, offset);

end