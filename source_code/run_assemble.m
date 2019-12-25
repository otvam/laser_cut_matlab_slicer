function run_assemble()
%RUN_ASSEMBLE Generate a 3d object from images with boundary information.
%
%   See also GET_ASSEMBLE, PLOT_ASSEMBLE,.

%   Thomas Guillod.
%   2019 - BSD License.

close('all')
addpath(genpath('fct'))

%% data_img
for i=1:11
    img_data{i}.img = struct(...
        'img', imread(['data/data/' num2str(i) '.bmp']),...
        'scale', 174./2012,...
        'simplify_tol', 0.1,...
        'h_growth', 1.3,...
        'h_min', 1.0,...
        'h_max', 20.0,...
        'dz', 4.0...
        );
end

%% data_merge
idx_vec = [11:-1:1 1:+1:11];
z_vec = linspace(-42, 42, 22);
for i=1:22
    merge_data{i} = struct(...
        'perm', [1 2 3],...
        'idx', idx_vec(i),...
        'offset', [0.0 0.0 z_vec(i)]...
        );
end

%% run
fv = get_assemble(img_data, merge_data);

%% save
save('data/export/assemble.mat', 'fv')
stl_write('data/export/assemble.stl', 'fv', fv)

end
