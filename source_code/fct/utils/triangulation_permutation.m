function fv = triangulation_permutation(fv, perm)
%TRIANGULATION_PERMUTATION Permute the axes of a triangulation.
%   fv = TRIANGULATION_PERMUTATION(fv, perm)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%   perm - array with the permutation (vector)
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the vertices
assert(length(perm)==3, 'invalid offset')
assert(any(perm==1), 'invalid offset')
assert(any(perm==2), 'invalid offset')
assert(any(perm==3), 'invalid offset')
vertices = fv.vertices;

% permute the vertices
fv.vertices(:,1) = vertices(:, perm(1));
fv.vertices(:,2) = vertices(:, perm(2));
fv.vertices(:,3) = vertices(:, perm(3));

end
