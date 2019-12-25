function run_slice()
%RUN_SLICE Slice a 3d object file with different cut planes.
%
%   See also GET_SLICE, PLOT_SLICE,.

%   Thomas Guillod.
%   2019 - BSD License.

close('all')
addpath(genpath('fct'))

%% load
fv = stl_read('data/data/model.stl');

%% stl_data
fv_data.scale = 1.0;
fv_data.perm = [1 2 3];
fv_data.offset = [0.0 0.0 0.0];

%% cut_data
z_vec = 2:4:42;
for i=1:length(z_vec)
   cut_data{i} = struct(...
       'axis', 'z',...
       'value', z_vec(i),...
       'simplify_thr', 1e-9...
       ); 
end

%% run
[fv, cut] = get_slice(fv, fv_data, cut_data);

%% save
save('data/export/slice.mat', 'fv', 'cut')
stl_write('data/export/slice.stl', 'fv', fv)

end