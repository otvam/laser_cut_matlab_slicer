function fv = triangulation_merge(fv_cell)
%TRIANGULATION_MERGE Merge different triangulation together.
%   fv = TRIANGULATION_MERGE(fv_cell)
%   fv_cell - input triangulation content (cell)
%      fv_cell{i}.vertices - vertices matrix (matrix)
%      fv_cell{i}.faces - triangulation faces matrix (matrix)
%      fv_cell{i}.bnd - boundary edges matrix (matrix)
%   fv - merged triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%
%   Merge different triangulation. Simplify the redundant vertices.
%   Keep all the faces, including internal faces.
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D, TRIANGULATION_CLEAN.

%   Thomas Guillod.
%   2019 - BSD License.

% init
faces = [];
vertices = [];
bnd = [];

% merge and update the indices
for i=1:length(fv_cell)
    n_offset = size(vertices, 1);
    faces = [faces ; fv_cell{i}.faces+n_offset];
    bnd = [bnd ; fv_cell{i}.bnd+n_offset];
    vertices = [vertices ; fv_cell{i}.vertices];
end

% clean the redundant vertices
[vertices, faces, bnd] = triangulation_clean(vertices, faces, bnd);

% assign
fv.faces = faces;
fv.vertices = vertices;
fv.bnd = bnd;

end