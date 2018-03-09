function defect_detector(path, trained_model_path, trained_model_file, image_directory_path)
%This function goes through a directory of images and detects the defects
%in them. The defects are saved in a csv-file.
%path is the path to Predictions.py file in string format
%trained_model_path is the path to the directory with the trained model in string format
%trained_model_file is the name of the trained model file in string format
%image_directory_path is the path to the directory with the images in string format

change_directory = strcat("cd ", path);
system(change_directory)

command = strcat("python Predictions.py ", trained_model_path , " " , trained_model_file , " " + image_directory_path);
system(command)

end