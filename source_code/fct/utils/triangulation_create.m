function [vertices, faces, bnd] = triangulation_create(c_cell, h_growth, h_min, h_max)
%TRIANGULATION_CREATE Create a 2d triangulation from contours with holes.
%   [vertices, faces] = TRIANGULATION_CREATE(c_cell, h_growth, h_min, h_max)
%   c_cell - cell array with the contours (cell)
%      c_cell{i}.pts - contour points (matrix)
%      c_cell{i}.is_cut - if the contour is a hole (boolean)
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
%   See also CONTOUR_CREATE, TRIANGULATION_2D_TO_3D, GENERATEMESH, GEOMETRYFROMEDGES.

%   Thomas Guillod.
%   2019 - BSD License.

% init the name of the contours
name = {};
name_cut = {};
name_ext = {};

% for each contour, prepare the polygons
for i=1:length(c_cell)
        % extract
    c_tmp = c_cell{i};
    n_tmp = size(c_tmp.pts, 1);
    x_tmp = c_tmp.pts(:,1).';
    y_tmp = c_tmp.pts(:,2).';
    is_cut_tmp = c_tmp.is_cut;
    
    % polygon data
    n_vec(i) = n_tmp;
    poly_cell{i} = [2 n_tmp-1 x_tmp(1:end-1) y_tmp(1:end-1)];
    
    % name tag
    name{end+1} = ['P_' num2str(i)];
    if is_cut_tmp==true
        name_cut{end+1} = ['P_' num2str(i)];
    else
        name_ext{end+1} = ['P_' num2str(i)];
    end
end

% get the matrix with the polygon data
poly_mat = get_poly(poly_cell, n_vec);

% get the polygon tag and the add/sub for the exterior contours and the holes
[name_mat, add_sub_str] = get_assemble(name, name_cut, name_ext);

% create geom
geom = decsg(poly_mat, add_sub_str , name_mat);

% create mesh
model = createpde();
geometryFromEdges(model, geom);
mesh = generateMesh(model, 'GeometricOrder', 'linear', 'Hgrad', h_growth, 'Hmin', h_min, 'Hmax', h_max);

% assign the mesh
vertices = mesh.Nodes.';
faces = mesh.Elements.';

% get the boundary elements
tri = triangulation(faces, vertices);
bnd = freeBoundary(tri);

end

function poly_mat = get_poly(poly_cell, n_vec)
%GET_POLY Create a unique polygon matrix by zero padding the contours.
%   poly_mat = GET_POLY(poly_cell, n_vec)
%   poly_cell - cell with the different polygon (cell of vector)
%   n_vec - size of the different polygon (vector)
%   poly_mat - zero padded polygon matrix (matrix)

poly_mat = zeros(max(n_vec), length(poly_cell));
for i=1:length(poly_cell)
    poly_mat(1:length(poly_cell{i}), i) = poly_cell{i};
end

end

function [name_mat, add_sub_str] = get_assemble(name, name_cut, name_ext)
%GET_ASSEMBLE Create the polygon tag and the assembly instruction (add/sub).
%   [name_mat, add_sub_str] = GET_ASSEMBLE(name, name_cut, name_ext)
%   name - cell with the polygon names (cell of string)
%   name_cut - cell with the holes to substract (cell of string)
%   name_ext - cell with the exterior boundaries to add (cell of string)
%   name_mat - matrix with the names (matrix)
%   add_sub_str - string with the add/sub instructions (matrix)

% create the name matrix
name_mat = char(name).';

% add/sub
if isempty(name_cut)
    % no hole, add everything
    add_sub_str = strjoin(name_ext, '+');
else
    % add the holes
    name_cut = strjoin(name_cut, '+');
    
    % for each exterior boundary, remove the holes
    for i=1:length(name_ext)
        add_sub_all{i} = [name_ext{i} '-(' name_cut ')'];
    end
    
    % join everything
    add_sub_str = strjoin(add_sub_all, '+');
end

end