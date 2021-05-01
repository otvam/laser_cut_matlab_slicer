function fv = get_assemble_part(img_data)
%GET_ASSEMBLE_PART Transform a 2d images into contours and a plate.
%   fv = GET_ASSEMBLE_PART(img_data)
%   img_data - information for transformer the images to plates (struct)
%      img_data.img - color image with the contour information (matrix)
%      img_data.scale - size per pixel of the image (scalar)
%      img_data.simplify_tol - angular tolerance for contour simplification (scalar)
%      img_data.h_growth - growth rate of the mesh (scalar)
%      img_data.h_min - minimal mesh element (scalar)
%      img_data.h_max - maximal mesh element (scalar)
%      img_data.dz - thickness of the plate (scalar)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%
%   See also GET_ASSEMBLE.

%   Thomas Guillod.
%   2019 - BSD License.

% extract
img = img_data.img;
scale = img_data.scale;
simplify_tol = img_data.simplify_tol;
h_growth = img_data.h_growth;
h_min = img_data.h_min;
h_max = img_data.h_max;
dz = img_data.dz;

% transform the image into binary
img = rgb2gray(img);
img = imbinarize(img);
img = img==false;

% rotate coordinate
img = fliplr(img.');

% get the contours of the image
c_cell = contour_create(img, scale);
c_cell = contour_simplify(c_cell, simplify_tol);

% create the 2d triangulation
[vertices_2d, faces_2d, bnd_2d] = triangulation_create(c_cell, h_growth, h_min, h_max);

% extrude the 2d triangulation into a plate
[vertices, faces, bnd] = triangulation_2d_to_3d(vertices_2d, faces_2d, bnd_2d, dz);

% assign the data
fv.faces = faces;
fv.vertices = vertices;
fv.bnd = bnd;

% disp
fprintf('    img = %d x %d\n', size(img,1), size(img,2));
fprintf('    contour = %d\n', length(c_cell));
fprintf('    vertices = %d\n', size(vertices, 1));
fprintf('    faces = %d\n', size(faces, 1));
fprintf('    bnd = %d\n', size(bnd, 1));

end