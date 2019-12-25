function fv = triangulation_scale(fv, scale)
%TRIANGULATION_SCALE Scale (stretch) a triangulation.
%   fv = TRIANGULATION_SCALE(fv, scale)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%   scale - scaling factor (scalar)
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the vertices
vertices = fv.vertices;

% scale the vertices
fv.vertices(:,1) = scale.*vertices(:,1);
fv.vertices(:,2) = scale.*vertices(:,2);
fv.vertices(:,3) = scale.*vertices(:,3);

end
