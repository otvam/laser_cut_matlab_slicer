function plot_assemble()
%PLOT_ASSEMBLE Plot a 3d object composed of stacked plates.
%   Plot the faces, the edges, and the boundaries.
%   The data are generated with 'run_assemble.m'.
%
%   See also PLOT_3D_ASSEMBLE, RUN_ASSEMBLE.

%   Thomas Guillod.
%   2019 - BSD License.

close('all')
addpath(genpath('fct'))

%% load
data_tmp = load('data/export/assemble.mat');
fv = data_tmp.fv;

%% plot
plot_data = get_plot_data([-40 -120]);
plot_3d_assemble(plot_data, fv)
print(gcf ,'data/export/assemble_3d_1.png','-dpng','-r300')

plot_data = get_plot_data([0 +90]);
plot_3d_assemble(plot_data, fv)
print(gcf ,'data/export/assemble_3d_2.png','-dpng','-r300')

plot_data = get_plot_data([-20 70]);
plot_3d_assemble(plot_data, fv)
print(gcf ,'data/export/assemble_3d_3.png','-dpng','-r300')

end

function plot_data = get_plot_data(pos_angle)

plot_data.pos_angle = pos_angle;
plot_data.face_color = [0.8 0.8 1.0];
plot_data.edge_color = 'k';
plot_data.edge_alpha = 0.1;
plot_data.line_color = 'b';
plot_data.line_width = 1;

end