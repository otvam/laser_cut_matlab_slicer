function stl_write(filename, name, fv)
%STL_WRITE Write a binary STL file.
%   STL_WRITE(filename, name, fv)
%   filename - the file to be written (string)
%   name - file name (string)
%   fv - file content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%
%   See also STL_READ.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the data
faces = fv.faces;
vertices = fv.vertices;
n_faces = size(faces, 1);
n_vertices = size(vertices, 1);

% check the data size
assert(n_faces>=1, 'invalid face number')
assert(n_vertices>=3, 'invalid vertices number')
assert(size(vertices, 2)==3, 'invalid vertices matrix size')
assert(size(faces, 2)==3, 'invalid faces matrix size')
assert(length(name)<=80, 'invalid name length')

% create the points
x_1 = vertices(faces(:,1), 1);
x_2 = vertices(faces(:,2), 1);
x_3 = vertices(faces(:,3), 1);
y_1 = vertices(faces(:,1), 2);
y_2 = vertices(faces(:,2), 2);
y_3 = vertices(faces(:,3), 2);
z_1 = vertices(faces(:,1), 3);
z_2 = vertices(faces(:,2), 3);
z_3 = vertices(faces(:,3), 3);

% get the normal vector
d_12 = [x_2-x_1 y_2-y_1 z_2-z_1];
d_13 = [x_3-x_1 y_3-y_1 z_3-z_1];
n = d_12(:,[2 3 1]).*d_13(:,[3 1 2])-d_13(:,[2 3 1]).*d_12(:,[3 1 2]);
n = n./sqrt(sum(n.*n, 2));

% create the components
n_1 = n(:,1);
n_2 = n(:,2);
n_3 = n(:,3);

% assign the facets
facets(1,1,:) = n_1;
facets(1,2,:) = x_1;
facets(1,3,:) = x_2;
facets(1,4,:) = x_3;

facets(1,1,:) = n_2;
facets(2,2,:) = y_1;
facets(2,3,:) = y_2;
facets(2,4,:) = y_3;

facets(1,1,:) = n_3;
facets(3,2,:) = z_1;
facets(3,3,:) = z_2;
facets(3,4,:) = z_3;

% open the file
fid = fopen(filename, 'wb+');

% write header
fprintf(fid, '%-80s', name);
fwrite(fid, n_faces, 'uint32');

% write data
facets = single(facets);
facets = typecast(facets(:), 'uint16');
facets = reshape(facets, 12.*2, n_faces);
facets = [facets ; zeros(1, n_faces)];
fwrite(fid, facets, 'uint16');

% close the file
fclose(fid);

end