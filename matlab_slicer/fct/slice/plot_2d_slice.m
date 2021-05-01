function plot_2d_slice(plot_data, fv, cut)
%PLOT_2D_SLICE Plot a the cut planes in 2d.
%   PLOT_2D_SLICE(plot_data, fv, cut)
%   plot_data - plot information (struct)
%      plot_data.line_map - function handle for the colormap (fct handle)
%      plot_data.line_width - line width of the cut lines (scalar)
%      plot_data.margin - margin around the object (scalar)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines (matrix)
%
%   The figure is scaled for the right dimension.
%   All the dimensions are considered in millimeters.
%
%   See also GET_SLICE, PLOT_3D_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

% get axis
axis_data = get_axis_data(fv, plot_data.axis, plot_data.margin);
idx_cut = get_idx_cut(cut, plot_data.axis);

% init figure
figure()
set(gcf,'Units','centimeters')
set(gcf,'PaperPositionMode','Auto')
set(gcf,'PaperUnits','centimeters')
set(gcf,'PaperSize', 0.1.*[axis_data.d_x axis_data.d_y])
set(gcf, 'Position', 0.1.*[axis_data.d_offset axis_data.d_offset axis_data.d_x axis_data.d_y]);
set(gca,'Position', [0 0 1 1])
hold('on')

% plot lines
color_map = plot_data.line_map(length(idx_cut));
for i=1:length(idx_cut)
    cut_tmp = cut{idx_cut(i)};
    x = cut_tmp.pts(:, axis_data.idx_x);
    y = cut_tmp.pts(:, axis_data.idx_y);
    plot(x, y, 'Color', color_map(i,:), 'LineWidth', plot_data.line_width)
end

% axis
xlim([axis_data.x_min axis_data.x_max]);
ylim([axis_data.y_min axis_data.y_max]);
axis('off')
axis('equal')

end

function axis_data = get_axis_data(fv, axis, margin)
%GET_AXIS_DATA Get the axis size and information.
%   axis_data = GET_AXIS_DATA(fv, axis, margin)
%   fv - triangulation content (struct)
%      fv.vertices - vertices matrix (matrix)
%      fv.faces - triangulation faces matrix (matrix)
%   axis - name of the chosen cut plane ('x', 'y', 'z') (string)
%   margin - margin around the object (scalar)
%   axis_data - axis information (struct)
%       axis_data.idx_x - index (1, 2, or 3) of the x axis (scalar)
%       axis_data.idx_y - index (1, 2, or 3) of the y axis (scalar)
%       axis_data.x_min - minumum of the x axis (scalar)
%       axis_data.x_max - maximum of the x axis (scalar)
%       axis_data.y_min - minumum of the y axis (scalar)
%       axis_data.y_max - maximum of the y axis (scalar)
%       axis_data.d_x - figure size along the x axis (scalar)
%       axis_data.d_y - figure size along the y axis (scalar)
%       axis_data.d_offset - figure offset from the bottom (scalar)

% find the axis in 3d corresponding to x and y in 2d
switch axis
    case 'x'
        axis_data.idx_x = 3;
        axis_data.idx_y = 2;
    case 'y'
        axis_data.idx_x = 1;
        axis_data.idx_y = 3;
    case 'z'
        axis_data.idx_x = 1;
        axis_data.idx_y = 2;
    otherwise
        error('invalid data')
end

% extract data
size_x_tmp = fv.vertices(:, axis_data.idx_x);
size_y_tmp = fv.vertices(:, axis_data.idx_y);

% get figure limit
axis_data.x_min = min(size_x_tmp)-margin;
axis_data.x_max = max(size_x_tmp)+margin;
axis_data.y_min = min(size_y_tmp)-margin;
axis_data.y_max = max(size_y_tmp)+margin;

% get figure size
axis_data.d_x = axis_data.x_max-axis_data.x_min;
axis_data.d_y = axis_data.y_max-axis_data.y_min;
axis_data.d_offset = margin;

end

function idx_cut = get_idx_cut(cut, axis)
%GET_IDX_CUT Get the indices of the planes along the specified axis.
%   idx_cut = GET_IDX_CUT(cut, axis)
%   cut - extracted cut lines (cell)
%      cut{i}.axis - name of the cut plane ('x', 'y', 'z') (string)
%      cut{i}.pts - points of the cut lines (matrix)
%   axis - name of the chosen cut plane ('x', 'y', 'z') (string)
%   idx_cut - indices of the plane along the specified axis (vector)

idx_cut = [];
for i=1:length(cut)
    cut_tmp = cut{i};
    if strcmp(cut_tmp.axis, axis)
        idx_cut(end+1) = i;
    end
end

end