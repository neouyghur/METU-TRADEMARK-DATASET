% Author
%   osman tursun, osmanjan.t@gmail.com
%
% Refrence 
%   [1]Video Google: A Text Retrieval Approach to Object Matching
%      in Videos (especially for rank2)
%
% Date:
%   Aug 14 2015
%
% Quote:
%   “Life will always get busy, make time to do the things you love.” 
%                               - Lailah Gifty Akita, Beautiful Quotes
% Last access:
%   Feb. 17 2018
%
% Tip:
%   clearvars -except dataInfo similarity
%
% Note: 
%   Solving tie problems with cosidering worst cases

query_folder1 = dataInfo(1).folder;
query_pt1 = dataInfo(1).pt;
nFile1 = dataInfo(1).fileNo; % file number

% other logos
query_folder2 = dataInfo(2).folder;
query_pt2 = dataInfo(2).pt;
nFile2 = dataInfo(2).fileNo; % file number

nFile = nFile1 + nFile2;
file_logo_list = dataInfo(1).fll_lfl;
logo_file_list = dataInfo(2).fll_lfl;
%%

%% get mean rank and PR
recall= [0:0.1:1];
%
worst_precision = ones(1, length(recall));

%[file_logo_list logo_file_list] = getSll(nFile1, query_pt1);
%change similarity function

sortInfo = [];
for i=1:nFile1
    start2 = tic;
    [B, IX] = sort(similarity(i,:),'ascend');
    sortInfo(i).value = B;
    sortInfo(i).Index = IX;
    sorttime(i) = toc(start2);
end

fprintf('average and std of similarity sort time: %g, %g\n\n', mean(sorttime), std(sorttime));

rank_info = [];
for i = 1:nFile1
    B = sortInfo(i).value;
    IX = sortInfo(i).Index;
    data = similarity(i, :);
    list = logo_file_list{file_logo_list(i)};
    best_rankArr = arrayfun(@(x) find(IX == x, 1, 'first'), list ); % best case
    worst_rankArr = arrayfun(@(x) find(B == data(IX(x)), 1, 'last'), best_rankArr );
    worst_rank_info{i} = sort(worst_rankArr, 'ascend');
    worst_rank1(i) = mean(worst_rankArr);
    nRel = length(list);
    worst_rank2(i) = 1/(nFile*nRel)*(sum(worst_rankArr) - nRel*(nRel + 1)/2);  % check refrence 1
end

worst_mean_rank1 = mean(worst_rank1);
worst_mean_rank2 = mean(worst_rank2);
worst_std1 = std(worst_rank1);
worst_std2 = std(worst_rank2);

%% Mean Average Precison
average_precision = zeros(1, nFile1);
for j = 1:nFile1
    rel_list = logo_file_list{file_logo_list(j)}; % relevent logos
    relevent = 1:length(rel_list);
    worst_rankArr = worst_rank_info{j};
    average_precision(j) = mean(relevent./worst_rankArr(relevent));
    %average_precision(j) = sum(relevent./worst_rankArr(relevent))/size(relevent, 2);
end
mean_average_precision = mean(average_precision);
fprintf('Mean average precision: %g\n', mean_average_precision)


%% Mean Average Precison @ K
k = [50, 100, 200, 400];
for i=1:size(k, 2)
    average_precision = zeros(1, nFile1);
    for j = 1:nFile1
        rel_list = logo_file_list{file_logo_list(j)}; % relevent logos
        relevent = 1:length(rel_list);
        worst_rankArr = worst_rank_info{j};
        thesh = max(find(worst_rankArr < k(i)));
        average_precision(j) = sum(relevent(1:thesh)./worst_rankArr(relevent(1:thesh)))/size(relevent, 2);
    end
    mean_average_precision = mean(average_precision);
    fprintf('Mean average precision at %d : %g\n', k(i), mean_average_precision)
end

%% Average Precison Recall Graph
worst_prcs_matrix = ones(nFile1, length(recall) - 1);
for i= 2:length(recall)
    for j = 1:nFile1
          rel_list = logo_file_list{file_logo_list(j)}; % relevent logos
          relevent = int8(recall(i) * length(rel_list));
          worst_rankArr = worst_rank_info{j};
          worst_prcs_matrix(j,i) = relevent/worst_rankArr(relevent);
    end
    worst_precision(i) = mean(worst_prcs_matrix(:,i));
end

disp(sprintf('--- Worst Case ---'));
disp(sprintf('rank1, std1: %.1f %.1f', worst_mean_rank1, worst_std1));
disp(sprintf('rank2, std2: %.3f %.3f', worst_mean_rank2, worst_std2));
% disp(sprintf('\n'));
figure;
plot(recall, worst_precision, 'm.-');
% title('Worst');
% stat.worst.rank1 = worst_rank1;
% stat.worst.rank2 = worst_rank2;
% stat.worst.std1 = worst_std1;
% stat.worst.std2 = worst_std2;
% stat.worst.mean_rank1 = worst_mean_rank1;
% stat.worst.mean_rank2 = worst_mean_rank2;
% stat.worst.prcs_matrix = worst_prcs_matrix;
% stat.worst.precision = worst_precision;
% %
% %
% stat.recall = recall;
% save result
%save('/media/osman/megamind/descriptor_data/ORSIFT/SIFT_default/SIFT_10k_930k_result', 'stat', '-v7.3');