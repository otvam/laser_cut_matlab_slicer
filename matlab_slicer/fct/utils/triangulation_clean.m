function [vertices, faces, bnd] = triangulation_clean(vertices, faces, bnd)
%TRIANGULATION_CLEAN Simplify the redundent vertices in a triangulation.
%   [vertices, faces, bnd] = TRIANGULATION_CLEAN(vertices, faces, bnd)
%   vertices - vertices matrix (matrix)
%   faces - triangulation faces matrix (matrix)
%   bnd - boundary edges matrix (matrix)
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D.

%   Thomas Guillod.
%   2019 - BSD License.

% remove the redundant vertices
[vertices, idx, idx_rev] = unique(vertices, 'rows');

% update the face indices
faces(:,1) = idx_rev(faces(:,1));
faces(:,2) = idx_rev(faces(:,2));
faces(:,3) = idx_rev(faces(:,3));

% update the bnd indices
bnd(:,1) = idx_rev(bnd(:,1));
bnd(:,2) = idx_rev(bnd(:,2));

end