function generate_mirror_csv(file_to_read, file_to_write, image_path)
    % file_to_read: path/filename to csv file containing annotations to mirror
    % file_to_write: path/filename where to save generated csv file
    % image_path: will be written in the beginning of each line of
    % generated file. If original file had image_name: 'Acrorad_21441.jpg'
    % and image_path = 'data/img/train/' is given 'data/img/train/'Acrorad_21441.jpg'
    % is written before coordinates to generated file.
    
    % set image_path empty string, if it is not given as a parameter
    if ~exist('image_path','var')
        image_path = ''; 
    end

    % open csv file to read annotations
    File = fopen(file_to_read, 'r');

    % open csv file to write new content
    % if file already exists this will override its content
    file = fopen(file_to_write, 'w');

    % read lines to string (or char)
    lines = textscan(File, '%s');
    lines = lines{1};
    fclose(File);

    write_lines(file, lines, image_path, '.jpg');
    write_lines(file, lines, image_path, 'x.jpg');
    write_lines(file, lines, image_path, 'y.jpg');

    fclose(file);
end

%% To avoid repetition
function write_lines(file, lines, image_path, image_name_ending)
    formatSpec1 = strcat(image_path,'%s,%i,%i,%i,%i,%s\n');
    formatSpec2 = strcat(image_path,'%s,,,,,\n'); % for images with no defects

    [n, ~] = size(lines);

    for ind=1:n
        % split line to reach numbers
        content = strsplit(lines{ind},',');

        % generate name of image
        image_name = content{1};
        Cell = strsplit(image_name, '.');
        name = strcat(Cell{1}, image_name_ending);

        if length(content) == 2  % image has no defects
            fprintf(file, formatSpec2, name);
        else
            % convert to numbers
            x1 = str2num(content{2});
            y1 = str2num(content{3});
            x2 = str2num(content{4});
            y2 = str2num(content{5});

            % test will coordinates be mirrored
            if contains(image_name_ending, 'x')
                x1 = 1280 - str2num(content{4}); % im_width - initial_x2
                x2 = 1280 - str2num(content{2}); % im_width - initial_x1
            elseif contains(image_name_ending, 'y')
                y1 = 1024 - str2num(content{5}); % im_heigth - initial_y2
                y2 = 1024 - str2num(content{3}); % im_heigth - initial_y1
            end

            class = content{6};

            fprintf(file, formatSpec1, name, x1, y1, x2, y2, class);
        end
    end
end