%% Load label data 
% parameter of load function is path + name of imagefile
Data = load('Acrorad_1503-3101-1-01-0(1021-1022)LABELS.mat');

% change to more reachable datatype
Labels = Data.labels;

from = 1
to = 2 % Amount of images drawn is (from - to + 1)


%% Second image to Matlab image data-type

for i=from:to
    figure(i)
    
    % generate name of image to read 
    number = 1020 + i;
    name = "Acrorad_1503-3101-1-01-0" + number + ".jpg";
    name = char(name);
    
    % show image
    img = imread(name);
    imagesc(img);
    colormap(gray)
   % set(gcf, 'Position', [100, 100, 1080, 1200])
    
    % draw rectangles to one image
    color = 'red';
        
    coordinates = Labels{i, 2};
    [m, n] = size(coordinates);
        
    if m > 0
        for k=1:m
            x = coordinates(k,1);
            y = coordinates(k,2);
            dx = coordinates(k,3);           
            dy = coordinates(k,4);
            drawRectangle(x, y, dx, dy, color)
        end    
    end  
    
    im_name = "LABELLED/Acrorad_0712-1001-1-07-0" + number + "LABEL.jpg"
    %% saveas(figure(i),im_name)
end    



%% Function to draw rectangle limiting defect
function drawRectangle(x, y, dx, dy, color) 
    line([x, x+dx],[y ,y], 'Color', color );
    line([x, x+dx],[y+dy ,y+dy], 'Color', color);
    line([x, x],[y, y+dy], 'Color', color);
    line([x+dx, x+dx],[y, y+dy], 'Color', color);
end