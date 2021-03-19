% Author
%   osman tursun, osmanjan.t@gmail.com
%
% Date:
%   Oct. 08 2017
% 
% Quote:
%   “Do not go where the path may lead; go instead where there is no path and leave a trail” - Ralph Waldo Emerson
%

warning('have you changed the file list, please check it\n');
warning('have you changed the name of saving file, please check it\n');
warning('have you changed the normalized function\n');
prompt = 'Do you? y/n [y]: ';
str = input(prompt, 's');
if ~strcmp(str, 'y')
    return;
end

% ==============================
% Output similarity matrix to a file for evaluation 
save_str = '/media/osman/megamind/NN_GYM/learn_image_transformation_4_IR/features&similarity/similarities/vgg16_caffe-conv5-3-relu-rmac-256-PCAw-p2.mat';
% Features are saved in h5 file
file_list = {'/media/osman/megamind/TTA_DATA/METU/features/merged_feature/vgg16_caffe-conv5-3-relu-rmac-256-PCAw-p2.h5'};
% ===============================

query_folder1 = dataInfo(1).folder;
query_pt1 = dataInfo(1).pt;
nFile1 = dataInfo(1).fileNo; % file number

% other logos
query_folder2 = dataInfo(2).folder;
query_pt2 = dataInfo(2).pt;
nFile2 = dataInfo(2).fileNo; % file number

nFile = nFile1 + nFile2;

%% Hack
% nFile=10000;
% warning('nFile is %d\n', nFile);

%%
% Get HDF5 dataset
dataset = getHdf5DataList(file_list, 0, 0);

start1 = tic;
similarity = [];
for i = 1:length(dataset)
    % normr is for normalization
      data = normr(squeeze(hdf5read(dataset(i).dir, dataset(i).name))');
    %Normalization
    if i == 1
        query_data = data(1:nFile1, :);
        disp(size(query_data))
    end
    
    temp_similarity = single(ones(nFile1, size(data, 1)));
    for j = 1:nFile1
        temp_similarity(j,:) = sum((data - query_data(j,:)).^2, 2);
    end
    similarity = [similarity temp_similarity];
end
end1 = toc(start1);
similarity = similarity(:, 1:nFile); % Overfit

disp(sprintf('average distant calculate time is %g', end1/nFile1));
save(save_str, 'similarity', '-v7.3');