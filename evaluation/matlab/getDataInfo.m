FOLDER1 = '/home/osman/datasets/METU_TRADEMARK_DATASET/square/queries/'; % query logos
FOLDER2 = '/home/osman/datasets/METU_TRADEMARK_DATASET/square/pool/'; % Other logos except for queries
OUTPUT_STR = './DataInfo_930k_ac.mat'; % output
%% get image files
% query logos
query_folder1 = FOLDER1;
query_pt1 = dir(strcat(query_folder1, '/*.jpg'));
nFile1 = length(query_pt1); % file number
% We don't need this three line code
[file_logo_list logo_file_list] = getSll(nFile1, query_pt1);
fll = file_logo_list;
lfl = logo_file_list;

% other logos
query_folder2 = FOLDER2;
query_pt2 = dir(strcat(query_folder2, '/*.jpg'));
nFile2 = length(query_pt2); % file number
nFile = nFile1 + nFile2; % total No of image file

folder = {query_folder1, query_folder2};
pt = {query_pt1, query_pt2};
fileNo = {nFile1, nFile2};
fll_lfl = {fll, lfl};
dataInfo = struct('folder', folder, 'pt', pt, 'fileNo', fileNo, 'fll_lfl', fll_lfl);
% save data
save(OUTPUT_STR, 'dataInfo');