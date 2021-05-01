function [vertices, faces, bnd] = triangulation_2d_to_3d(vertices_2d, faces_2d, bnd_2d, dz)
%TRIANGULATION_2D_TO_3D Transform a 2d triangulation into a 3d plate.
%   [vertices, faces, bnd] = TRIANGULATION_2D_TO_3D(vertices_2d, faces_2d, bnd_2d, dz)
%   vertices_2d - vertices matrix in 2d (matrix)
%   faces_2d - triangulation faces matrix in 2d (matrix)
%   bnd_2d - boundary edges matrix in 2d (matrix)
%   dz - thickness of the plate (scalar)
%   vertices - vertices matrix in 3d (matrix)
%   faces - triangulation faces matrix in 3d (matrix)
%   bnd - boundary edges matrix in 3d (matrix)
%
%   Keep the triangulation for the up and down faces.
%   Use the bnd matrix for connecting both faces.
%   In the third dimension, the plate goes from -dz/2 to +dz/2.
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_CLEAN.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the number of vertices
n_vertices = size(vertices_2d, 1);

% vertices: up, down
vertices_up = [vertices_2d , +(dz./2).*ones(n_vertices, 1)];
vertices_dw = [vertices_2d , -(dz./2).*ones(n_vertices, 1)];
vertices = [vertices_up ; vertices_dw];

% add faces: up, down, connecting
faces_up = faces_2d(:, [1 2 3])+0.*n_vertices;
faces_dw = faces_2d(:, [2 1 3])+1.*n_vertices;
bnd_1 = [bnd_2d(:, [2 1]) , bnd_2d(:,1)+n_vertices];
bnd_2 = [bnd_2d(:, [1 2])+n_vertices , bnd_2d(:,2)];
faces = [faces_up ; faces_dw ; bnd_1 ; bnd_2];

% add bnd: up, down
bnd_up = bnd_2d+0.*n_vertices;
bnd_dw = bnd_2d+1.*n_vertices;
bnd = [bnd_up ; bnd_dw];

% clean the redundant vertices
[vertices, faces, bnd] = triangulation_clean(vertices, faces, bnd);

end
