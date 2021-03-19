% Author
%   osman tursun, osmanjan.t@gmail.com
%
% Refrence 
%   [1]Video Google: A Text Retrieval Approach to Object Matching
%      in Videos (especially for rank2)
% Date:
%   04/08/2015
% 
% Quote:
%   “Do not go where the path may lead; go instead where there is no path and leave a trail” - Ralph Waldo Emerson
%
% Last access:
%   Mar 19. 2016
%

warning('have you checked the key number, please check it\n');
warning('have you changed the name of saving file, please check it\n');
prompt = 'Do you? y/n [y]: ';
str = input(prompt,'s');
if ~strcmp(str, 'y')
    return;
end

% ==============================
KEY_NUMBER = 9;
save_str = 'output/sift_9_similarity';
% ===============================

query_folder1 = dataInfo(1).folder;
query_pt1 = dataInfo(1).pt;
nFile1 = dataInfo(1).fileNo; % file number
[file_logo_list logo_file_list] = getSll(nFile1, query_pt1);
dataInfo(1).fll = file_logo_list;
dataInfo(1).lfl = logo_file_list;

% other logos
query_folder2 = dataInfo(2).folder;
query_pt2 = dataInfo(2).pt;
nFile2 = dataInfo(2).fileNo; % file number

nFile = nFile1 + nFile2;
nKey = KEY_NUMBER;

% get similarity
loopHead = 1;
similarity = single(ones(nFile1, nFile));
start_tm = tic;

for i = 1:nFile1
    tfidf1 = tfidf(i);
    if(~isempty(tfidf1.word))
        tfidf1_arr = single(zeros(1, nKey));
        tfidf1_arr(tfidf1.word) = tfidf1.value;
        norm1 = norm(tfidf1_arr);
        parfor j = 1:nFile
            tfidf2 = tfidf(j);
            if(~isempty(tfidf2.word))
                tfidf2_arr = single(zeros(1, nKey));
                tfidf2_arr(tfidf2.word) = tfidf2.value;
                temp1 = sum(tfidf1_arr.*tfidf2_arr, 2);
                temp2 = norm1*norm(tfidf2_arr);
                similarity(i, j) = 1 - temp1/temp2; 
            end
        end
    end
end

end_tm = toc(start_tm);
clear tfidf;
disp(sprintf('average similarity calculating time %g', end_tm/nFile1));
save(save_str, 'similarity', '-v7.3');