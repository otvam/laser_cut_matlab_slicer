function [vertices, faces, bnd] = triangulation_create(c_cell, h_growth, h_min, h_max)
%TRIANGULATION_CREATE Create a 2d triangulation from contours with holes.
%   [vertices, faces] = TRIANGULATION_CREATE(c_cell, h_growth, h_min, h_max)
%   c_cell - cell array with the contours (cell of matrix)
%   h_growth - growth rate of the mesh (scalar)
%   h_min - minimal mesh element (scalar)
%   h_max - maximal mesh element (scalar)
%   vertices - vertices matrix (matrix)
%   faces - triangulation faces matrix (matrix)
%   bnd - boundary edges matrix (matrix)
%
%   Using the PDE toolbox, transform the contour into a PDE problem.
%   In a second step, mesh the PDE and found the boundary elements.
%
%   See also CONTOUR_CREATE, TRIANGULATION_2D_TO_3D, GENERATEMESH, GEOMETRYFROMMESH.

%   Thomas Guillod.
%   2020 - BSD License.

% for each contour, prepare the polygons
for i=1:length(c_cell)
    c_tmp = c_cell{i};
    x_vec{i} = c_tmp(:,1).';
    y_vec{i} = c_tmp(:,2).';
end

% get the polygon and make the triangulation
poly = polyshape(x_vec, y_vec, 'Simplify', false);
tr = triangulation(poly);

% create the pde
model = createpde();

% create the geometry
nodes = tr.Points.';
elements = tr.ConnectivityList.';
geometryFromMesh(model, nodes, elements);

% generate the mesh
mesh = generateMesh(model, 'GeometricOrder', 'linear', 'Hgrad', h_growth, 'Hmin', h_min, 'Hmax', h_max);

% assign the mesh
vertices = mesh.Nodes.';
faces = mesh.Elements.';

% get the boundary elements
tri = triangulation(faces, vertices);
bnd = freeBoundary(tri);

end