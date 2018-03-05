%% Label images
% After labeling two sets of images these sets can be combined with
% following
%
% First load them from memory with like:
% parameter of load function is path + name of imagefile
% Data = load('path/file.mat');
% Labels = Data.labels    subcellarray C(1:3, 1:2)
% 
% combinedCellArray = [Labels1 ; Labels2]
%
% Then save it with descriptive name

% Change variables 'from' and 'to' to choose images to label  
from = 230
to = 231 % Amount of images drawn is (from - to + 1)
n = to - from + 1

labels = cell(n,3);

figure(1)
for i=from:to
    
    % generate name of image to read 
    number = 1000 + i;
    name = "Acrorad_1503-3101-1-01-0" + number + ".jpg";
    name = char(name);
    
    % Show image
    img = imread(name);
    clf
    imshow(img)
    
    
    % Collect data by clicking with mouse
    A = [0, 0];
    X = [];
    Y = [];
    classes = [];
    counter = 0;
    
    while ~isempty(A)
        counter = counter + 1;
        hold on
        [x,y] = ginput(1);
        X = [X; x];
        Y = [Y; y];
        
        if rem(counter, 2) == 0
            classes = [classes; "round"];
        end    
       
        plot(x,y, 'r*', 'LineWidth', 2)
       
        A  = [x, y];  
    end
    
    labels{i-from + 1,1} = name;
    labels{i-from + 1,2} = label(X, Y);
    labels{i-from + 1,3} = classes;
end   
%% rename file to save (first word after save)
%save 'Acrorad_1503-3101-1-01-0(1130-1168)LABELS.mat' labels 

labels2csv('Acrorad_1503-3101-1-01-0(1230-1233)LABELS.csv', labels, 'data/imgs/train/')

function label_vec =  label(x, y)
    x = floor(x);
    y = floor(y);
    l_x = length(x);
    label_vec = zeros(l_x/2,4);

    for j=1:(l_x/2)
        index = (2*j-1);
        dx = x(index+1) - x(index);
        dy = y(index+1) - y(index);
        %%%%% how to add classes to labels?
        %%% this will turn coordinate integers to strings
        %%% alternative options is to use same kind of format as in our csv
        %%% files ... OR ADD CLASSES VECTOR WITH AS MANY ROWS AS COORDINATES FOR EACH IMAGE
        label_vec(j,:) = [x(index) y(index) dx dy];      
    end   
    
    if l_x == 0
        label_vec = [];
    end    
    
    label_vec;
end



