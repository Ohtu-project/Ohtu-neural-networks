%% CLASSES NEED TO BE STILL HANDLED SOMEHOW

function labels2csv(file_name, labels, path, mirror_x, mirror_y)
% Writes cell array content into a csv file. This is our annotation file
% given to neural network in training or testing phase
%
% CELL2CSV(file_name, labels, path, mirror_x, mirror_y)
%
% file_name     = name of the file to save [ i.e. 'text.csv' ]
% labels        = Cell Array containing bounding box labels for images
% path          = (relative) path to labeled images
% mirror_x      = optional boolean defining is mirroring x-coordinates done 
% mirror_y      = optional boolean defining is mirroring y-coordinates done
% Both mirror parametres are true by default
%
% Ensio Suonperä 2.3.2018

    if ~exist('mirror_x','var')
        mirror_x = true;
    end    

    if ~exist('mirror_y','var')
        mirror_y = true;
    end

    %% Write file
    fid = fopen(file_name, 'w');

    write_lines(fid, labels, path, '.jpg')

    if mirror_x
        write_lines(fid, labels, path, 'x.jpg')
    end    
    
    if mirror_y
        write_lines(fid, labels, path, 'y.jpg')
    end
    
    % Closing file
    fclose(fid);
end

%% To avoid repetition
function write_lines(file, labels, path, image_name_ending)
    formatSpec1 = strcat(path,'%s,%i,%i,%i,%i,%s\n');
    formatSpec2 = strcat(path,'%s,,,,,\n'); % for images with no defect

    [n, ~] = size(labels);

    for i=1:n
        coordinates = labels{i,2};
        [m, ~] = size(coordinates)
    
            name = labels{i,1};
            Cell = strsplit(name, '.');
            name = strcat(Cell{1}, image_name_ending);
            classes = labels{i,3}
            
        if m > 0
            for k=1:m
                x1 = coordinates(k,1);
                y1 = coordinates(k,2);
                x2 = x1 + coordinates(k,3);
                y2 = y1 + coordinates(k,4);
                class = classes(k)
                fprintf(file, formatSpec1, name, x1, y1, x2, y2, class);
            end
        else
            fprintf(file, formatSpec2, name);
        end
    end
end