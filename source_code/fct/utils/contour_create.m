function c_cell = contour_create(img, scale)
%CONTOUR_CREATE Extract contours from an image taking the holes into account.
%   c_cell = CONTOUR_CREATE(img, scale)
%   img - binary image with the contour information (matrix)
%   scale - size per pixel of the image (scalar)
%   c_cell - cell array with the contours (cell)
%      c_cell{i}.pts - contour points (matrix)
%      c_cell{i}.is_cut - if the contour is a hole (boolean)
%
%   See also CONTOUR_SIMPLIFY, BWBOUNDARIES.

%   Thomas Guillod.
%   2019 - BSD License.

% find boundary
[bnd, label, n] = bwboundaries(img, 'holes');

% parse the contours
for i=1:length(bnd)
    bnd_tmp = bnd{i};
    assert(all(bnd_tmp(1,:)==bnd_tmp(end,:)), 'contour is not closed')
    
    c_tmp.pts = scale.*bnd_tmp;
    c_tmp.is_cut = i > n;
    c_cell{i} = c_tmp;
end

end