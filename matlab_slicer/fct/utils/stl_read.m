function fv = stl_read(filename)
%STL_READ Read a binary STL file.
%   fv = STL_READ(filename)
%   filename - the file to be read (string)
%   fv - file content (struct)
%      fv.name - file name (string)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.normal - normal vector matrix (matrix)
%
%   Simplify (remove) the redundant vertices.
%
%   See also STL_WRITE.

%   Thomas Guillod.
%   2019 - BSD License.

% read the file
assert(isfile(filename), 'invalid filename')
fid = fopen(filename,'r');
data = fread(fid,inf,'uint8=>uint8');
fclose(fid);

% parse the file
[name, v, f, n] = extract_stl(data);

% clean the file
[v, f] = clean_stl(v, f);

% assign the output
fv = struct('name', name,  'vertices', v, 'faces', f, 'normal', n);

end

function [name, v, f, n] = extract_stl(data)
%EXTRACT_STL Parse the content of a binary STL file.
%   [name, v, f, n] = EXTRACT_STL(data)
%   data - data to be parsed (vector)
%   name - file name (string)
%   v - vertices matrix (matrix)
%   f - triangulation matrix (matrix)
%   n - normal vector matrix (matrix)

% check/decode the header
assert(length(data)>=84, 'invalid stl header')
name = strtrim(native2unicode(data(1:80)).');
n_faces = typecast(data(81:84), 'uint32');
assert(n_faces>0, 'invalid stl header')

% remove the header and the unsunsed data
data = data(85:end);
assert(length(data)>=50, 'invalid stl data')
idx = [49:50:length(data) 50:50:length(data)];
data(idx) = [];

% read the facets
facets = double(typecast(data, 'single'));
facets = reshape(facets, 12 ,length(facets)./12);
facets = reshape(facets, 3, 4, n_faces);

% extract data
n_1 = squeeze(facets(1,1,:));
x_1 = squeeze(facets(1,2,:));
x_2 = squeeze(facets(1,3,:));
x_3 = squeeze(facets(1,4,:));

n_2 = squeeze(facets(1,1,:));
y_1 = squeeze(facets(2,2,:));
y_2 = squeeze(facets(2,3,:));
y_3 = squeeze(facets(2,4,:));

n_3 = squeeze(facets(1,1,:));
z_1 = squeeze(facets(3,2,:));
z_2 = squeeze(facets(3,3,:));
z_3 = squeeze(facets(3,4,:));

% vertices
v = [...
    x_1 y_1 z_1;...
    x_2 y_2 z_2;...
    x_3 y_3 z_3;...
    ];

% normal vector
n = [n_1 n_2 n_3];

% faces
f_1 = 0.*n_faces+(1:n_faces);
f_2 = 1.*n_faces+(1:n_faces);
f_3 = 2.*n_faces+(1:n_faces);
f = [f_1.' f_2.' f_3.'];

end

function [v, f] = clean_stl(v, f)
%CLEAN_STL Remove the redundant vertices.
%   [v, f] = CLEAN_STL(v, f)
%   v - vertices matrix (matrix)
%   f - triangulation faces matrix (matrix)

% remove the redundant vertices
[v, idx, idx_rev] = unique(v, 'rows');

% update the face indices
f(:,1) = idx_rev(f(:,1));
f(:,2) = idx_rev(f(:,2));
f(:,3) = idx_rev(f(:,3));

end