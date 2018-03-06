function labelling_tool

window_width = 1500;
window_heigth = 1200;
image_width = 1280;
image_heigth = 1024;
button_width = 100;
button_heigth = 25;
margin = 20;
button_width_start = image_width;
button_heigth_start = window_heigth - button_heigth - margin;

folder = "/home/lauimmon/Ohtuprojekti/NN/Neural Network Trainung Data/Defect training/";

images = dir(char(folder + "*.jpg"));
index = 1;

name_first = images(1).name;
name_last = images(length_of(images)).name;
% !name csv file according to image numbers
csv_file = fopen(char(folder + "LABELS.csv"), 'w');

%  Create and then hide the UI as it is being constructed.
f = figure('Visible','off','Position',[margin, margin,window_width,window_heigth]);

% Construct the components.
next_image   = uicontrol('Style','pushbutton',...
             'String','Done','Position',[button_width_start,button_heigth_start - button_heigth,button_width * 0.7,button_heigth],...
             'Callback',@nextimage_callback);
undo         = uicontrol('Style','pushbutton',...
             'String','Undo','Position',[button_width_start + button_width,button_heigth_start - button_heigth,button_width * 0.5,button_heigth],...
             'Callback',@undo_callback);   
text_classes = uicontrol('Style','text','String','Select classes',...
             'Position',[button_width_start,button_heigth_start - margin - button_heigth * 2,button_width,button_heigth]);
round        = uicontrol('Style','pushbutton',...
             'String','Round','Position',[button_width_start,button_heigth_start - margin * 2 - button_heigth * 3,button_width,button_heigth],...
             'Callback',@round_callback);
hexagonal    = uicontrol('Style','pushbutton',...
             'String','Hexagonal','Position',[button_width_start,button_heigth_start - margin * 3 - button_heigth * 4,button_width,button_heigth],...
             'Callback',@hexagonal_callback); 
trigonal     = uicontrol('Style','pushbutton',...
             'String','Trigonal','Position',[button_width_start,button_heigth_start - margin * 4 - button_heigth * 5,button_width,button_heigth],...
             'Callback',@trigonal_callback);  
square       = uicontrol('Style','pushbutton',...
             'String','Square','Position',[button_width_start,button_heigth_start - margin * 5 - button_heigth * 6,button_width,button_heigth],...
             'Callback',@square_callback);        
unclear      = uicontrol('Style','pushbutton',...
             'String','Unclear','Position',[button_width_start,button_heigth_start - margin * 6 - button_heigth * 7,button_width,button_heigth],...
             'Callback',@unclear_callback);       
double       = uicontrol('Style','pushbutton',...
             'String','Double','Position',[button_width_start,button_heigth_start - margin * 7 - button_heigth * 8,button_width,button_heigth],...
             'Callback',@double_callback);       

ha = axes('Units','pixels','Position',[0,window_heigth - image_heigth - margin,image_width,image_heigth],'Box','on');

% Initialize the UI.
% Change units to normalized so components resize automatically.
f.Units = 'normalized';
ha.Units = 'normalized';
next_image.Units = 'normalized';
undo.Units = 'normalized';
text_classes.Units = 'normalized';
round.Units = 'normalized';
hexagonal.Units = 'normalized';
trigonal.Units = 'normalized';
square.Units = 'normalized';
unclear.Units = 'normalized';
double.Units = 'normalized';

% Assign the a name to appear in the window title.
f.Name = images(index).name;

% Move the window to the center of the screen.
movegui(f,'center')

% Make the window visible.
f.Visible = 'on';

show_image();

empty_class = [0, 0, 0, 0, 0, 0];
points = [];
classes = [];
close = false;


while ~close
    hold on
    % ask inputs
    [x,y] = ginput(1);
    % only accept inputs inside the image
    if x > image_width || x < 0 || y > image_heigth || y < 0
       continue 
    end  
    
    if ~isempty(points)
        if is_even(points) && ~class_given()
            % !add a message warning about missing class
            continue
        end    
    end    
        
    % plot given input points
    plot(x,y, 'r*', 'LineWidth', 2)
       
    A  = [x, y];
    points = [points; A] % Add new point to matrix
    
    % if both points of a bounding box have been given, save points in a
    % right order and draw a box
    if is_even(points)
        draw_rectangles();  
        classes = [classes; empty_class];
    end   
end
fclose(csv_file)
% !tell user that all images have been labeled
   
    % switch to next image and reset input points.
    function show_new_image()
        index = index + 1;
        if index > length_of(images)
           close = true;
           return 
        end    
        
        show_image();
        
        points = [];
        classes = [];
    end  

    % show current image
    function show_image()
        cla(ha) % clear previous image
        f.Name = images(index).name;
        file_name = images(index).name;
        file_name = folder + file_name;
        file_name = char(file_name);
        img = imread(file_name);  
        imshow(img);
    end    

    % check if a necessary class has been given
    function given = class_given()
       len = length_of(classes);
       if len == 0
            given = false;
       else    
            given = (classes(len, 1) || classes(len, 2) || classes(len, 3) || classes(len, 4) || classes(len, 5));
    
       end
    end

    % add a class to a box
    function put_class(class)
        len = length_of(classes);
        if class == 6
           classes(len, class) = ~classes(len, class);
        else
           classes(len,:) = [0,0,0,0,0,classes(len,6)];
           classes(len,class) = 1;
        end    
    end    
    
    function length = length_of(matrix)
        [size_x, size_y] = size(matrix);
        length = size_x;
    end  

    % save given input points into a csv file
    function save_points()
        rearrange_points();
        
        len = length_of(points);
        
        for i=1:len/2
           x1 = floor(points(i*2 - 1, 1));
           x2 = floor(points(i*2, 1));
           y1 = floor(points(i*2 - 1, 2));
           y2 = floor(points(i*2, 2));
           [class1, class2] = class_names(i);
           fprintf(csv_file, '%s,%i,%i,%i,%i,%s,%s\n', images(index).name, x1, x2, y1, y2, class1, class2);
        end    
        
        if len == 0
           fprintf(csv_file, '%s,,,,,,\n', images(index).name);
        end    
    end  

    % return classes as class names
    function [class1, class2] = class_names(index)
        class2 = 'single';
        if classes(index, 1)
            class1 = 'round';
        end
        if classes(index, 2)
            class1 = 'hexagonal';
        end
        if classes(index, 3)
            class1 = 'trigonal';
        end
        if classes(index, 4)
            class1 = 'square';
        end
        if classes(index, 5)
            class1 = 'unclear';
        end
        if classes(index, 6)
            class2 = 'double';
        end
    end    

    % check if the ammount of items in a matrix is even
    function even = is_even(matrix)
        length = length_of(matrix);
        even = (mod(length,2) == 0);
    end    

    % rearrange the points so that for every box the first point is in the
    % upper left corner and the second point is the bottom right corner
    function rearrange_points()
        length = length_of(points);
        for i=1:length/2
            x1 = points(i*2 - 1, 1);
            x2 = points(i*2, 1);
            y1 = points(i*2 - 1, 2);
            y2 = points(i*2, 2);
            if ~(x2 > x1 && y2 > y1)
                if (x2 < x1 && y2 < y1)
                   points(i*2 - 1, 1) = x2;
                   points(i*2, 1) = x1;
                   points(i*2 - 1, 2) = y2;
                   points(i*2, 2) = y1;
                   return
                end    
                points(i*2 - 1, 2) = y2;
                points(i*2, 2) = y1;
                y1 = points(i*2 - 1, 2);
                y2 = points(i*2, 2);
                if (x2 < x1 && y2 < y1)
                   points(i*2 - 1, 1) = x2;
                   points(i*2, 1) = x1;
                   points(i*2 - 1, 2) = y2;
                   points(i*2, 2) = y1;
                   return
                end
            end 
        end
    end   

    % draw all rectangles
    function draw_rectangles()
       length = length_of(points);
       if length > 1
           ammount = floor(length/2);

           for i=1:ammount - 1
               draw_rectangle(i*2, 'blue');
           end   

           draw_rectangle(ammount*2, 'red');
       end    
    end    

    % draw one rectangle
    function draw_rectangle(i, color)
        x = min(points(i - 1, 1), points(i, 1));
        y = min(points(i - 1, 2), points(i, 2));
        dx = abs(points(i - 1, 1) - points(i, 1));
        dy = abs(points(i - 1, 2) - points(i, 2));
        plot_rectangle(x, y, dx, dy, color); 
    end 

    function plot_rectangle(x, y, dx, dy, color)
        line([x, x+dx],[y ,y], 'Color', color );
        line([x, x+dx],[y+dy ,y+dy], 'Color', color);
        line([x, x],[y, y+dy], 'Color', color);
        line([x+dx, x+dx],[y, y+dy], 'Color', color);
    end       

  % Push button callbacks. 

    function nextimage_callback(source,eventdata) 
        if (is_even(points) && class_given()) || isempty(points)
          save_points();
          show_new_image();
        else
          % !tell user that the ammount of points is wrong or class is
          % missing
        end  
    end    

    function undo_callback(source,eventdata) 
        length = length_of(points);
        points = points(1:length-1, 1:2);
        show_image();
        for i=1:length-1
            plot(points(i,1),points(i,2), 'r*', 'LineWidth', 2)
        end      
        draw_rectangles()
    end

    function round_callback(source,eventdata) 
        put_class(1);
    end

    function hexagonal_callback(source,eventdata) 
        put_class(2);
    end

    function trigonal_callback(source,eventdata) 
        put_class(3);
    end

    function square_callback(source,eventdata) 
        put_class(4);
    end

    function unclear_callback(source,eventdata) 
        put_class(5);
    end

    function double_callback(source,eventdata) 
        put_class(6);
    end
end