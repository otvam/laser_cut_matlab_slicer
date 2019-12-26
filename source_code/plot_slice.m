function plot_slice()
%PLOT_SLICE Plot a 3d object and the cut planes.
%   Make the plot in 3d for visulization.
%   Make the plot in 2d for PDF export.
%   The data are generated with 'run_slice.m'.
%
%   See also PLOT_3D_SLICE, PLOT_2D_SLICE, RUN_SLICE.

%   Thomas Guillod.
%   2019 - BSD License.

close('all')
addpath(genpath('fct'))

%% load
data_tmp = load('data/export/slice.mat');
cut = data_tmp.cut;
fv = data_tmp.fv;

%% plot_data
plot_data_3d.plot_stl = true;
plot_data_3d.plot_line = true;
plot_data_3d.pos_angle = [+40 -120];
plot_data_3d.face_color = [0.8 0.8 1.0];
plot_data_3d.edge_color = 'k';
plot_data_3d.edge_alpha = 0.1;
plot_data_3d.line_color = 'r';
plot_data_3d.line_width = 2;

plot_data_2d.line_map =  @parula;
plot_data_2d.line_width = 2;
plot_data_2d.margin = 10;
plot_data_2d.axis = 'z';

%% plot
plot_3d_slice(plot_data_3d, fv, cut)
print(gcf ,'data/export/slice_3d.png','-dpng','-r300')

plot_2d_slice(plot_data_2d, fv, cut)
print(gcf ,'data/export/slice_2d.pdf','-dpdf','-r0')

end