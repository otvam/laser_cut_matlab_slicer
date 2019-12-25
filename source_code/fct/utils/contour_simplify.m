function c_cell = contour_simplify(c_cell, simplify_tol)
%CONTOUR_SIMPLIFY Simplify contour with a given angular tolerance.
%   c_cell = contour_simplify(c_cell, simplify_tol)
%   c_cell - cell array with the contours (cell)
%      c_cell{i}.pts - contour points (matrix)
%      c_cell{i}.is_cut - if the contour is a hole (boolean)
%   simplify_tol - angular tolerance for contour simplification (scalar)
%
%   See also CONTOUR_CREATE, REDUCEM.

%   Thomas Guillod.
%   2019 - BSD License.

% simplify all the contours
for i=1:length(c_cell)
    c_tmp = c_cell{i};
    [x_tmp, y_tmp] = reducem(c_tmp.pts(:,1), c_tmp.pts(:,2), simplify_tol);
    c_cell{i}.pts = [x_tmp, y_tmp];
    c_cell{i}.is_cut = c_tmp.is_cut;
end

end
