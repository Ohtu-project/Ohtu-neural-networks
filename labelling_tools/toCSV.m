%% convert labels Cell Array to CSV file

%% Load label data 
% parameter of load function is path + name of imagefile
Data = load('Acrorad_1503-3101-1-01-0(1051-1099)LABELS.mat');

% change to more reachable datatype
Labels = Data.labels;

% Not really using this variable path later, should refactor to use
path = "data/imgs/train/" 

fid = fopen('train_annotations3_mirror.csv', 'w')

% from and to are not now the numbers of images but numbers of rows in Data
from = 1
to = 49 % Amount of images drawn is (from - to + 1)

formatSpec1 = 'data/imgs/train/%s,%i,%i,%i,%i,defect\n';
formatSpec2 = 'data/imgs/train/%s,,,,,\n'; % for images with no defect

for i=from:to
    
    index = i-from+1;
    coordinates = Labels{index,2};
    [m, n] = size(coordinates);
        
    if m > 0
        for k=1:m
            x1 = coordinates(k,1);
            y1 = coordinates(k,2);
            x2 = x1 + coordinates(k,3);           
            y2 = y1 + coordinates(k,4);
            fprintf(fid, formatSpec1, Data.labels{index,1}, x1, y1, x2, y2);
        end    
    else 
        fprintf(fid, formatSpec2, Data.labels{index,1});
    end
end    

%% For mirror in x direction

formatSpec1x = 'data/imgs/train/%s,%i,%i,%i,%i,defect\n';
formatSpec2x = 'data/imgs/train/%s,,,,,\n';

for i=from:to
    
    index = i-from+1;
    coordinates = Labels{index,2};
    [m, n] = size(coordinates);
    
    name = Data.labels{index,1};
    Cell = strsplit(name, '.');
    name = strcat(Cell{1},'x.jpg');
    
    if m > 0
        for k=1:m
            x2 = 1280 - coordinates(k,1);
            y1 = coordinates(k,2);
            x1 = 1280 - (coordinates(k,1) + coordinates(k,3));           
            y2 = y1 + coordinates(k,4);
            fprintf(fid, formatSpec1x, name , x1, y1, x2, y2);
        end    
    else 
        fprintf(fid, formatSpec2x, name);
    end
end 

%% For mirror in y direction

formatSpec1y = 'data/imgs/train/%s,%i,%i,%i,%i,defect\n';
formatSpec2y = 'data/imgs/train/%s,,,,,\n';

for i=from:to
    
    index = i-from+1;
    coordinates = Labels{index,2};
    [m, n] = size(coordinates);
     
    name = Data.labels{index,1};
    Cell = strsplit(name, '.');
    name = strcat(Cell{1},'y.jpg');
    
    if m > 0
        for k=1:m
            x1 = coordinates(k,1);
            y2 = 1024 - coordinates(k,2);
            x2 = coordinates(k,1) + coordinates(k,3);           
            y1 = 1024 - (coordinates(k,2) + coordinates(k,4));
            fprintf(fid, formatSpec1y, name , x1, y1, x2, y2);
        end    
    else 
        fprintf(fid, formatSpec2y, name);
    end
end 
fclose(fid);