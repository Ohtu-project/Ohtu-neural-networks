function defect_detector(path, trained_model_path, trained_model_file, image_directory_path)
%This function goes through a directory of images and detects the defects
%in them. The defects are saved in a csv-file.
change_directory = strcat("cd ", path);
system(change_directory)

command = strcat("python Predictions.py ", trained_model_path + " " + trained_model_file + " " + image_directory_path);
system(command)

end