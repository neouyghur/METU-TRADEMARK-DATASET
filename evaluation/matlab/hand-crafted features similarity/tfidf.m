function  tfidf = tfidf(shape, varargin)
%  Author:
%   Osman Tursun, osmanjan.t@gmail.com

%  Change:
%       04/08/2015
%       1. 'clear shape' command is added.
%  Last Acees:
%       Mar 19, 2016

if (length(varargin) == 2)
    nImage = varargin{1};
    nKey = varargin{2};
elseif(length(varargin) == 1)
    nImage = varargin{1};
    nKey = max(horzcat(shape(:).label));
elseif(length(varargin) == 0)
    nImage = length(shape);
    nKey = max(horzcat(shape(:).label));
else
    error('Wrong Input at tfidf');
end

disp(sprintf('Key number is %d', nKey));
disp(sprintf('Image number is %d', nImage));

% get unique elements of each cell of laberArr
labels = [1:nKey];

%Tip : min(horzcat(shape(:).label))
warning('have you checked the label index(0,1 c, matlab) problem, please check it\n');
% if label start from 0
% for i = 1 : nImage
%    if(~isempty(shape(i).label))
%        shape(i).label = shape(i).label + 1;
%    end
% end

% calculate each word's occurant time in files
occur = zeros(1, nKey);
for i = 1 : nImage
    temp = zeros(1, nKey);
    temp(shape(i).label) = 1;
    occur = occur + temp; 
end

tfidf = [];
for i = 1 : nImage
    tfidf(i).word = shape(i).label;
    nWord = length(shape(i).label);
    if(nWord == 0)
        tfidf(i).value = [];
        continue;
    end
    tf =  double(shape(i).lrpc) / double(shape(i).fn);
    idf = log10(nImage./occur(shape(i).label));
    tfidf(i).value = single(tf.*idf);
end
clear shape;
%save('output/ORSIFT_tfidf', 'tfidf', '-v7.3');