function cut = get_slice_cut(fv, cut_data)
%GET_SLICE_CUT Cut the triangulation with different planes.
%   cut = GET_SLICE_CUT(fv, cut_data)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   cut_data - information for slicing the 3d fv (struct)
%      cut_data.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut_data.value - coordinate of the cut along the specified axis (scalar)
%      cut_data.value - coordinate of the cut along the specified axis (scalar)
%      cut_data.simplify_thr - thresold for connecting points (scalar)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines (matrix)
%
%   See also GET_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

% extract
axis = cut_data.axis;
value = cut_data.value;
simplify_thr = cut_data.simplify_thr;

% get the cut plane
switch axis
    case 'x'
        p_0 = [value 0 0];
        n = [1 0 0];
    case 'y'
        p_0 = [0 value 0];
        n = [0 1 0];
    case 'z'
        p_0 = [0 0 value];
        n = [0 0 1];
    otherwise
        error('invalid data')
end

% get the intersection
[c, n_pts] = triangulation_contour(fv, p_0, n, simplify_thr);

% assemble the different contours (NaN as a separator)
pts = [];
for i=1:length(c)
    pts = [pts ; c{i} ; NaN(1, 3)];
end

% assign the data
cut.pts = pts;
cut.axis = axis;

% disp
fprintf('    contour = %d\n', length(cut));
fprintf('    vertices = %d\n', n_pts);

end