function plot_3d_slice(plot_data, fv, cut)
%PLOT_3D_SLICE Plot a 3d triangulation with cut planes.
%   PLOT_3D_SLICE(plot_data, fv, cut)
%   plot_data - plot information (struct)
%      plot_data.pos_angle - view angle in 3d (vector)
%      plot_data.face_color - face color of the triangulation (vector or string)
%      plot_data.edge_color - edge color of the triangulation (vector or string)
%      plot_data.edge_alpha - edge transparency of the triangulation (scalar)
%      plot_data.line_color - line color of the cut lines (vector or string)
%      plot_data.line_width - line width of the cut lines (scalar)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines (matrix)
%
%   See also GET_SLICE, PLOT_2D_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

% init figure
figure()
hold('on')

% triangulation
patch(...
    'Faces', fv.faces,...
    'Vertices', fv.vertices,...
    'FaceColor', plot_data.face_color,...
    'EdgeColor', plot_data.edge_color,...
    'EdgeAlpha', plot_data.edge_alpha...
    );

% cut lines
for i=1:length(cut)
    cut_tmp = cut{i};
    x = cut_tmp.pts(:,1);
    y = cut_tmp.pts(:,2);
    z = cut_tmp.pts(:,3);
    plot3(x, y, z, 'Color', plot_data.line_color, 'LineWidth', plot_data.line_width)
end

% axis
axis('tight')
axis('off')
axis('equal')
material('dull');
view(plot_data.pos_angle)
camlight('headlight')

end