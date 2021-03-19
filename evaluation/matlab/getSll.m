function [fll, lfl] = getSll(nFile, pt)
% Usage:
%   Queryset similar group

% Author
%   osman tursun, osmanjan.t@gmail.com
% Date
%  Mar 18, 2016
% Quote
%  “Wisdom is knowing what to do next; virtue is doing it.” - David Starr Jordan


%% constant
nFile1 = nFile;
query_pt1 = pt;

% get similar logo list
min_lgid = 1;
max_lgid = 0;
for i =1: nFile1
    scount = 1; % count of similar logo
    image_name = query_pt1(i).name;
    exp = '\d+.jpg$';
    temp_str = regexp(image_name,exp,'match');
    exp = '\d+';
    temp_str = regexp(temp_str,exp,'match');
    logo_id = str2num(cell2mat(temp_str{1}));
    max_lgid = max(logo_id,max_lgid);
    file_logo_list(i) = logo_id;
end

scount = 1;
temp = [];
for i = 1: max_lgid
    for j =1: nFile1
       if (file_logo_list(j) == i)
            temp(scount) = j;
            scount = scount + 1;
       end
    end
    logo_file_list{i} = temp;
    temp =[];
    scount = 1;
end

fll = file_logo_list;
lfl = logo_file_list;

end