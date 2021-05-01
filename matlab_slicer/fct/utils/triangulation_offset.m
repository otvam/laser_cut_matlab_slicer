function fv = triangulation_offset(fv, offset)
%TRIANGULATION_OFFSET Offset (translate) a triangulation.
%   fv = TRIANGULATION_OFFSET(fv, x, y, z)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%   offset - array with the offsets (vector)
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the vertices
assert(length(offset)==3, 'invalid offset')
vertices = fv.vertices;

% shift the vertices
fv.vertices(:,1) = vertices(:,1)+offset(1);
fv.vertices(:,2) = vertices(:,2)+offset(2);
fv.vertices(:,3) = vertices(:,3)+offset(3);

end
