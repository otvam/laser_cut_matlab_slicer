function [c, n_pts] = triangulation_contour(fv, p_0, n, simplify_thr)
%TRIANGULATION_CONTOUR Get the contour between a triangulation and a plane.
%   [c, n_pts] = TRIANGULATION_CONTOUR(fv, p_0, n, simplify_thr)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%   p_0 - plane reference point (vector)
%   n - plane normal vector (vector)
%   simplify_thr - thresold for connecting points (scalar)
%   c - cell array with the contours matrix (cell of matrix)
%   n_pts - number of vertices in the contours (scalar)
%
%   Get the intersection and assemble the segments to form contours.
%   Use a loop for matching the segment into a single curve.
%
%   See also TRIANGULATION_CREATE, TRIANGULATION_2D_TO_3D, TRIANGULATION_INTERSECT.

%   Thomas Guillod.
%   2019 - BSD License.

% extract the triangle vertices
p_1 = fv.vertices(fv.faces(:,1),:);
p_2 = fv.vertices(fv.faces(:,2),:);
p_3 = fv.vertices(fv.faces(:,3),:);

% get the intersection of the triangles
[is_int, p_c_1, p_c_2] = triangulation_intersect(p_0, n, p_1, p_2, p_3);

% eliminate segment with a single points
idx = (is_int==true)&(sqrt(sum((p_c_1-p_c_2).^2, 2))>simplify_thr);
n_pts = nnz(idx);
p_c_1 = p_c_1(idx,:);
p_c_2 = p_c_2(idx,:);

% first loop for the different contours
idx=1;
while (nnz(p_c_1)>0)&&(nnz(p_c_2)>0)
    % init the line
    c_tmp = p_c_1(1,:);
    
    % add the first segement
    c_tmp = add_segment_end(c_tmp, p_c_2(1,:), simplify_thr);
    [p_c_1, p_c_2] = delete_segment(p_c_1, p_c_2, 1);
    
    % inner loop for a specific contour
    flag = true;
    while (nnz(p_c_1)>0)&&(nnz(p_c_2)>0)&&(flag==true)
        % find the distances
        d_end_1 = get_distance(c_tmp(end,:), p_c_1);
        d_end_2 = get_distance(c_tmp(end,:), p_c_2);
        d_start_1 = get_distance(c_tmp(1,:), p_c_1);
        d_start_2 = get_distance(c_tmp(1,:), p_c_2);
        d = [d_end_1 d_end_2 d_start_1 d_start_2];
        
        % find the connected points
        idx_tmp = find(d<=simplify_thr);
        if nnz(idx_tmp)>0
            % connect the point
            idx_tmp = idx_tmp(1);
            [idx_face, type] = ind2sub(size(d), idx_tmp);
            
            % placement of the segment and the start or end
            switch type
                case 1
                    c_tmp = add_segment_end(c_tmp, p_c_2(idx_face,:), simplify_thr);
                case 2
                    c_tmp = add_segment_end(c_tmp, p_c_1(idx_face,:), simplify_thr);
                case 3
                    c_tmp = add_segment_start(c_tmp, p_c_2(idx_face,:), simplify_thr);
                case 4
                    c_tmp = add_segment_start(c_tmp, p_c_1(idx_face,:), simplify_thr);
            end
            [p_c_1, p_c_2] = delete_segment(p_c_1, p_c_2, idx_face);
        else
            % the line is terminated
            flag = false;
        end
    end
    % add the line
    c{idx} = c_tmp;
    idx=idx+1;
end

end

function d = get_distance(p_1, p_2)
%GET_DISTANCE Get the distance between points.
%   d = GET_DISTANCE(x, y)
%   p_1 - first point (matrix)
%   p_2 - first point (matrix)
%   d - distance between the points (vector)

d = sum((p_1-p_2).^2, 2);
d = sqrt(d);

end

function [p_c_1, p_c_2] = delete_segment(p_c_1, p_c_2, idx)
%DELETE_SEGMENT Delete a index in the intersection list.
%   [p_c_1, p_c_2] = DELETE_SEGMENT(p_c_1, p_c_2, idx)
%   p_c_1 - intersection first points (matrix)
%   p_c_2 - intersection second points (matrix)
%   idx - index to be deleted (scalar)

p_c_1(idx,:) = [];
p_c_2(idx,:) = [];

end

function c_tmp = add_segment_end(c_tmp, p, simplify_thr)
%ADD_SEGMENT_END Add a point at the end of the contour.
%   c_tmp = ADD_SEGMENT_END(c_tmp, p, simplify_thr)
%   c_tmp - matrix with the contour (matrix)
%   p - point to be added (vector)
%   simplify_thr - thresold for redundant points (scalar)

d = get_distance(c_tmp(end,:), p);
if d>simplify_thr
    c_tmp = [c_tmp ; p];
end

end

function c_tmp = add_segment_start(c_tmp, p, simplify_thr)
%ADD_SEGMENT_START Add a point at the start of the contour.
%   c_tmp = ADD_SEGMENT_START(c_tmp, p, simplify_thr)
%   c_tmp - matrix with the contour (matrix)
%   p - point to be added (vector)
%   simplify_thr - thresold for redundant points (scalar)

d = get_distance(c_tmp(1,:), p);
if d>simplify_thr
    c_tmp = [p ; c_tmp ];
end

end