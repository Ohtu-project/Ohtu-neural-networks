function defect_detector(path, trained_model_path, trained_model_file, image_directory_path)
%This function goes through a directory of images and detects the defects
%in them. The defects are saved in a csv-file in a same directory where Predictions.py is located. The function
%doesn't return anything so it is a void function.
%The function essentially just executes a system-command to run Predictions.py. Input parameters are the paths
%to necessary files and folders.
%parameter path is the path to matlab_integration folder in string format
%parameter trained_model_path is the path to the the trained model file in string format
%parameter image_directory_path is the path to the directory with the images in string format
%parameter csv_file is the name of the resulting csv-file. This can be an empty of nonexistent file as a new csv-file is created by the program.

change_directory = strcat("cd ", path);
system(change_directory)

command = strcat("python Predictions.py ", trained_model_path, " ", image_directory_path, " ", csv_file);
system(command)

end
