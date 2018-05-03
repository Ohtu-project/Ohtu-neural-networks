function M = labeling_tool
    % Create a cell array of function handles of all local functions
    functionhandles = localfunctions;
    
    % Create a map that has chars of all function handles as their key, so
    % that it is easy to call the functions outside of this file

    functions_ammount = length_of(functionhandles);
    keys = cell(1, functions_ammount);
    for i = 1:functions_ammount
       keys{i} = char(functionhandles{i});
    end 
    M = containers.Map(keys, functionhandles);
end

function run()
    global round hexagonal trigonal square unclear void bubbles single double warning
    global f ha

    % window, button and image size initialization
    global image_width image_heigth
    window_width = 1500;
    window_heigth = 1200;
    image_width = 1280;
    image_heigth = 1024;
    button_width = 125;
    button_heigth = 25;
    margin = 20;
    button_width_start = image_width;
    button_heigth_start = window_heigth - button_heigth - margin;

    % button colors
    global color_on color_off
    color_on = 'yellow';
    color_off = [0.95 0.95 0.95];

    global folder
    folder = uigetdir('', 'Select a folder containing .jpg images');

    if ~folder
        return
    end

    % determine the name of the csv file, where labels are saved
    global csv_file_name
    csv_file_name = fullfile(folder, 'LABELS.csv');

    % get all jpg files from the folder
    global images
    images = dir(fullfile(folder, '*.jpg'));
    if isempty(images)
        disp('No jpg images to label in that folder!');
        return
    end

    % open csv file if it already exists or create a new file
    csv_file = fopen(csv_file_name, 'r');
    csv_data = [];
    if csv_file ~= -1
        csv_data = fscanf(csv_file, '%s \n');
        fclose(csv_file);
    end

    % check which images have been labeled. 'index' is the index of the first
    % image, that has not been labeled
    global index
    index = 1;
    while true
       k = strfind(csv_data, images(index).name);
       if isempty(k)
          break
       end
       index = index + 1;
       if index > length_of(images)
           break
       end
    end
    
    % if some images have been labeled, ask user if they want to label only 
    % unlabelled images
    if index > 1
        if index > length_of(images)
            message_relabel = "All images have already been labeled. Do you want to label everything again or quit the program?";
            no_label_message = "Quit";
        else
            message_relabel = "Images from " + images(1).name + " to " + images(index - 1).name + " have already been labeled. Do you want to label everything again or continue labeling from image " + images(index).name + "?";
            no_label_message = "Continue labeling";
        end

        fmessage = figure('Visible','off','Position',[margin, margin,900,250]);
        text_relabel = uicontrol('Style','text','String',message_relabel,'HorizontalAlignment','center',...
                 'Position',[margin, 150, 850, 50]);
        relabel = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String','Relabel everything','Position',[2 * margin, margin,400,100],...
                 'Callback',@relabel_callback);
        no_relabel = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',no_label_message,'Position',[450, margin,400,100],...
                 'Callback',@no_relabel_callback);

        text_relabel.Units = 'normalized';
        relabel.Units = 'normalized';
        no_relabel.Units = 'normalized';
        
        fmessage.Visible = 'on';
        uiwait(gcf);
    end
    
    if index > length_of(images)
        return
    end
    
    %  Create and then hide the UI as it is being constructed.
    f = figure('Visible','off','Position',[margin, margin,window_width,window_heigth]);
    set(f, 'WindowKeyPressFcn',@keyPressCallback);
    set (f, 'WindowButtonMotionFcn', @mouseMove);
    
    button_texts = {'Round (r)', 'Hexagonal (h)', 'Trigonal (t)', 'Square (q)', 'Unclear (u)', 'Void (v)', 'Bubbles (b)', 'Single (s)', 'Double (d)'};
    class_names = {'round', 'hexagonal', 'trigonal', 'square', 'unclear', 'void', 'bubbles', 'single', 'double'};
    class_name_mapping = containers.Map(button_texts, class_names);

    help = 'Mark a defect by clicking any two opposite corners of the defect. When a red box is drawn around the defect, select classes shown on the right side. Selected classes are shown in yellow colour. Multiple defects can be seleted. Click ''Done'' when you have marked all defects in one image. Clicked points can be reversed with ''Undo'', but you cannot go back to a previous image.';
    
    % Construct the components.
    text_help    = uicontrol('Style','text','String',help,'HorizontalAlignment','left',...
                 'Position',[margin,button_heigth + 100,image_width,100]);
    next_image   = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String','Done (Enter)','Position',[button_width_start,button_heigth_start - button_heigth,button_width * 0.7,button_heigth],...
                 'Callback',@nextimage_callback);
    undo         = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String','Undo (ctrl)','Position',[button_width_start + button_width * 0.7 + margin,button_heigth_start - button_heigth,button_width * 0.7,button_heigth],...
                 'Callback',@undo_callback);
    text_shape   = uicontrol('Style','text','String','Select shape','HorizontalAlignment','left',...
                 'Position',[button_width_start,button_heigth_start - margin - button_heigth * 2,button_width * 2,button_heigth]);
    round        = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Round (r)",'Position',[button_width_start,button_heigth_start - margin * 2 - button_heigth * 3,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    hexagonal    = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Hexagonal (h)",'Position',[button_width_start,button_heigth_start - margin * 3 - button_heigth * 4,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    trigonal     = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Trigonal (t)",'Position',[button_width_start,button_heigth_start - margin * 4 - button_heigth * 5,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    square       = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Square (q)",'Position',[button_width_start,button_heigth_start - margin * 5 - button_heigth * 6,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    unclear      = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Unclear (u)",'Position',[button_width_start,button_heigth_start - margin * 6 - button_heigth * 7,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    void         = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Void (v)",'Position',[button_width_start,button_heigth_start - margin * 7 - button_heigth * 8,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    bubbles      = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Bubbles (b)",'Position',[button_width_start,button_heigth_start - margin * 8 - button_heigth * 9,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    text_double  = uicontrol('Style','text','String','Select single or double','HorizontalAlignment','left',...
                 'Position',[button_width_start,button_heigth_start - margin * 9 - button_heigth * 10,button_width * 2,button_heigth]);
    single       = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Single (s)",'Position',[button_width_start,button_heigth_start - margin * 10 - button_heigth * 11,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    double       = uicontrol('Style','pushbutton','BackgroundColor',color_off,...
                 'String',"Double (d)",'Position',[button_width_start,button_heigth_start - margin * 11 - button_heigth * 12,button_width,button_heigth],...
                 'Callback',@class_button_callback);
    warning      = uicontrol('Style','text','String','','HorizontalAlignment','left',...
                 'FontSize',15,'ForegroundColor','red','Visible','off','Position',[button_width_start,button_heigth_start - margin * 12 - button_heigth * 12 - 500,200,button_heigth * 20]);

    ha = axes('Units','pixels','Position',[0,window_heigth - image_heigth - margin,image_width,image_heigth],'Box','on');
    
    % Initialize the UI.
    % Change units to normalized so components resize automatically.
    f.Units = 'normalized';
    ha.Units = 'normalized';
    text_help.Units = 'normalized';
    next_image.Units = 'normalized';
    undo.Units = 'normalized';
    text_shape.Units = 'normalized';
    round.Units = 'normalized';
    hexagonal.Units = 'normalized';
    trigonal.Units = 'normalized';
    square.Units = 'normalized';
    unclear.Units = 'normalized';
    void.Units = 'normalized';
    bubbles.Units = 'normalized';
    text_double.Units = 'normalized';
    single.Units = 'normalized';
    double.Units = 'normalized';
    warning.Units = 'normalized';

    % Move the window to the center of the screen.
    movegui(f,'center')

    % Make the window visible.
    f.Visible = 'on';

    % initialize points and classes to be empty
    global points classes x y
    x = 0;
    y = 0;
    default_class = ["round" "single"];
    points = [];
    classes = [];

    % ask points and add them to the array repeatedly
    while true
        % hide previous warnings
        set(warning, 'Visible', 'off');
        
        show_image();
        hold on
        try
            if waitforbuttonpress
                continue
            end 
        catch
            fprintf('\nThe labels have been saved in file %s\n', csv_file_name);
            break
        end

        % only accept inputs inside the image
        if x > image_width || x < 0 || y > image_heigth || y < 0
           continue
        end

        % don't accept new point if two points are given, but no class is given
        if ~isempty(points)
            if is_even(points) && ~class_given(classes)
                set(warning, 'String', 'One of following classes needs to be selected: round, hexagonal, trigonal, square, unclear, void or bubbles', 'Visible', 'on');
                continue
            end
        end

        % Add new point to matrix
        A  = [x, y];
        points = [points; A];

        % if both points of a bounding box have been given, add a default class
        % for the box
        if is_even(points)
            classes = [classes; default_class];
        end
    end

  % tracking the mouse position

    function mouseMove(object, eventdata)
        % track the mouse position
        p = get(gca, 'CurrentPoint');
        x = p(1,1);
        y = p(1,2);

        if index <= length_of(images)
            show_image();
        end
    end

  % Keyboard shortcuts

    function keyPressCallback(source, eventdata)
       switch eventdata.Key
           case 'return'
               nextimage_callback(next_image, []);
           case 'control'
               undo_callback(undo, []);
           case 'r'
               class_button_callback(round, []);
           case 'h'
               class_button_callback(hexagonal, []);
           case 't'
               class_button_callback(trigonal, []);
           case 'q'
               class_button_callback(square, []); 
           case 'u'
               class_button_callback(unclear, []);
           case 'v'
               class_button_callback(void, []);
           case 'b'
               class_button_callback(bubbles, []);
           case 's'
               class_button_callback(single, []);
           case 'd'
               class_button_callback(double, []);
       end
    end

  % Push button callbacks.

    % save points of the current image and show next image
    function nextimage_callback(source,eventdata)
        if index > length_of(images)
            close_program();
        end
        if (is_even(points) && class_given(classes)) || isempty(points)
            save_points();
            show_new_image();
        elseif ~is_even(points)
            set(warning, 'String', 'Wrong ammount of points. Add or remove points before moving to next image.', 'Visible', 'on')
        else
            set(warning, 'String', 'One of following classes needs to be selected: round, hexagonal, trigonal, square or unclear', 'Visible', 'on')
        end
    end

    % clear last given point and show image
    function undo_callback(source,eventdata)
        points = remove_last_item(points);
        if ~is_even(points)
            classes = remove_last_item(classes);
        end
        show_image();
    end

    % when class button is pressed
    function class_button_callback(source, eventdata)
        if is_even(points) && ~isempty(points)
            class_name = class_name_mapping(source.String);
            classes = put_class(class_name, classes);
        end
        show_image();
    end

    function relabel_callback(source, eventdata)
        csv_file = fopen(csv_file_name, 'w');
        fclose(csv_file);
        index = 1;
        close(fmessage);
    end

    function no_relabel_callback(source, eventdata)
        close(fmessage);
    end
end

% check if the ammount of items in a matrix is even
function even = is_even(matrix)
    length = length_of(matrix);
    even = (mod(length,2) == 0);
end

% check the length of a matrix
function length = length_of(matrix)
    [length, ~] = size(matrix);
end

% remove the last item of a matrix
function matrix = remove_last_item(matrix)
    len = length_of(matrix);
    matrix = matrix(1:len-1, :);
end

% switch to next image
function show_new_image()
    global index images points classes
    index = index + 1;
    % tell user if the previous image was the last one
    if index > length_of(images)
        close_program();
        return
    end

    % reset points and classes for the new image
    points = [];
    classes = [];

    show_image();
end

function close_program()
    global f warning
    set(warning, 'String', 'All images have been labeled', 'Visible', 'on');
    pause(1)
    close(f)
end

% show current image, points and rectangles
function show_image()
    global index f ha images points folder
    cla(ha) % clear previous image
    f.Name = images(index).name;
    file_name = images(index).name;
    file_name = fullfile(folder, file_name);
    img = imread(file_name);
    imshow(img);

    % draw points
    for i=1:length_of(points)
        plot(points(i,1),points(i,2), 'r*', 'LineWidth', 2)
    end
    draw_rectangles(points);
    set_button_colors();
    draw_cursor_lines();
end

% draw horizontal and vertical lines from the mouse position
function draw_cursor_lines()
    global x y image_width image_heigth
    if x <= image_width && x >= 0 && y <= image_heigth && y >= 0
       plot([0 image_width], [y y], 'Color', 'black')
       plot([x x], [0 image_heigth], 'Color', 'black')
    end
end

% draw all rectangles
function draw_rectangles(points)
   length = length_of(points);
   if length > 1
       ammount = ceil(length/2);

       for i=1:ammount - 1
           draw_rectangle(points(i*2 - 1 : i*2, :), 'blue');
       end

       if is_even(points)
           draw_rectangle(points(ammount*2 - 1 : ammount*2, :), 'red');
       end
   end
end

% draw one rectangle from two points given in a matrix
function draw_rectangle(matrix, color)
    x = min(matrix(1, 1), matrix(2, 1));
    y = min(matrix(1, 2), matrix(2, 2));
    dx = abs(matrix(1, 1) - matrix(2, 1));
    dy = abs(matrix(1, 2) - matrix(2, 2));
    plot_rectangle(x, y, dx, dy, color);
end

% draw lines of a rectangle
function plot_rectangle(x, y, dx, dy, color)
    line([x, x+dx],[y ,y], 'Color', color );
    line([x, x+dx],[y+dy ,y+dy], 'Color', color);
    line([x, x],[y, y+dy], 'Color', color);
    line([x+dx, x+dx],[y, y+dy], 'Color', color);
end

% set button colors to match with the given classes
function set_button_colors()
   global round hexagonal trigonal square unclear void bubbles single double color_on color_off classes points
   set(round, 'BackgroundColor', color_off);
   set(hexagonal, 'BackgroundColor', color_off);
   set(trigonal, 'BackgroundColor', color_off);
   set(square, 'BackgroundColor', color_off);
   set(unclear, 'BackgroundColor', color_off);
   set(void, 'BackgroundColor', color_off);
   set(bubbles, 'BackgroundColor', color_off);
   set(single, 'BackgroundColor', color_off);
   set(double, 'BackgroundColor', color_off); 

   if isempty(classes) || ~is_even(points)
        return
   end

   % set right buttons on if needed
   len = length_of(classes);
   if classes(len, 1) == 'round'
       set(round, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'hexagonal'
       set(hexagonal, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'trigonal'
       set(trigonal, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'square'
       set(square, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'unclear'
       set(unclear, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'void'
       set(void, 'BackgroundColor', color_on);
   elseif classes(len, 1) == 'bubbles'
       set(bubbles, 'BackgroundColor', color_on);
   end

   if classes(len, 2) == 'single'
       set(single, 'BackgroundColor', color_on);
   elseif classes(len, 2) == 'double'
       set(double, 'BackgroundColor', color_on);
   end
end

% save given input points into a csv file
function save_points()
    global csv_file_name points classes index images
    csv_file = fopen(csv_file_name, 'a+');

    points = rearrange_points(points);

    len = length_of(points);

    for i=1:len/2
       x1 = floor(points(i*2 - 1, 1));
       x2 = floor(points(i*2, 1));
       y1 = floor(points(i*2 - 1, 2));
       y2 = floor(points(i*2, 2));
       class1 = classes(i, 1);
       class2 = classes(i, 2);
       fprintf(csv_file, '%s,%i,%i,%i,%i,%s_%s\n', char(images(index).name), x1, y1, x2, y2, class1, class2);
    end

    if len == 0
       fprintf(csv_file, '%s,,,,,\n', char(images(index).name));
    end
    fclose(csv_file);
end

% rearrange the points so that for every box the first point is in the
% upper left corner and the second point is the bottom right corner
function points = rearrange_points(points)
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
               continue
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
            end
        end
    end
end

% check if the necessary classes have been given
function given = class_given(classes)
   len = length_of(classes);
   if len == 0
        given = false;
   else
        given = ~(classes(len,1) == "" || classes(len,2) == "");
   end
end

% add a class to a box.
function classes = put_class(class, classes)
    len = length_of(classes);

    if class == "single" || class == "double"
       classes(len, 2) = class;
    else
       classes(len, 1) = class;
    end
end