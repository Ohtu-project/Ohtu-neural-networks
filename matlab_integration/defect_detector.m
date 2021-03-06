function defect_detector(path, trained_model_path, read_image_directory_path, save_image_directory_path, csv_file)
%This function goes through a directory of images and detects the defects
%in them. The defects are saved in a csv-file in a same directory where Predictions.py is located.
%Images with bounding boxes are saved in the directory determined by save_image_directory_path.
%The function doesn't return anything so it is a void function.
%The function essentially just executes a system-command to run Predictions.py. Input parameters are the paths
%to necessary files and folders.
%parameter path is the path to matlab_integration folder in string format
%parameter trained_model_path is the path to the the trained model file in string format
%parameter read_image_directory_path is the path to the directory with the images in string format
%parameter save_image_directory_path is the path to the directory where evaluated images with bounding
%boxes are saved.
%parameter csv_file is the name of the resulting csv-file. File of this name must not already exist
%as a new csv-file is created by the program.

change_directory = strcat("cd ", path);
system(change_directory)

command = strcat("python Predictions_mat.py ", trained_model_path, " ", read_image_directory_path, " ", save_image_directory_path, " ", csv_file);
system(command)

%P = py.sys.path;
%if count(P,'Predictions') == 0
%    insert(P,int32(0),'modpath');
%end
% tensorflowTest.m
%mod = py.importlib.import_module('Predictions');
%py.importlib.reload(mod);

end
