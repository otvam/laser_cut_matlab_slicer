function plot_3d_assemble(plot_data, fv)
%PLOT_3D_ASSEMBLE Plot a 3d triangulation with cut planes.
%   PLOT_3D_ASSEMBLE(plot_data, fv)
%   plot_data - plot information (struct)
%      plot_data.plot_stl - plot (or not) the STL file (boolean)
%      plot_data.plot_line - plot (or not) the boundaries (vector)
%      plot_data.pos_angle - view angle in 3d (vector)
%      plot_data.face_color - face color of the triangulation (vector or string)
%      plot_data.edge_color - edge color of the triangulation (vector or string)
%      plot_data.edge_alpha - edge transparency of the triangulation (scalar)
%      plot_data.line_color - line color of the boundary lines (vector or string)
%      plot_data.line_width - line width of the boundary lines (scalar)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%      fv.bnd - boundary edges matrix (matrix)
%
%   See also GET_ASSEMBLE.

%   Thomas Guillod.
%   2019 - BSD License.

% init figure
figure()
hold('on')

% triangulation
if plot_data.plot_stl==true
    patch(...
        'Faces', fv.faces,...
        'Vertices', fv.vertices,...
        'FaceColor', plot_data.face_color,...
        'EdgeColor', plot_data.edge_color,...
        'EdgeAlpha', plot_data.edge_alpha...
        );
end

% boundary
if plot_data.plot_line==true
    x_1 = fv.vertices(fv.bnd(:,1), 1);
    x_2 = fv.vertices(fv.bnd(:,2), 1);
    y_1 = fv.vertices(fv.bnd(:,1), 2);
    y_2 = fv.vertices(fv.bnd(:,2), 2);
    z_1 = fv.vertices(fv.bnd(:,1), 3);
    z_2 = fv.vertices(fv.bnd(:,2), 3);
    x_all = [x_1 x_2].';
    y_all = [y_1 y_2].';
    z_all = [z_1 z_2].';
    plot3(x_all, y_all, z_all, 'Color', plot_data.line_color, 'LineWidth', plot_data.line_width)
end

% axis
axis('tight')
axis('off')
axis('equal')
material('dull');
view(plot_data.pos_angle)
camlight('headlight')

end