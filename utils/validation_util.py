import os


def get_errors(arg):
    '''
    Used in validating the user input parameters in Predictions_mat.py. Returns a list of errors
    in parameters.  
    '''
    errors = []
    if not correct_number_of_arguments(errors, arg):
        return errors

    correct_model_file(errors, arg[1])
    correct_image_directory(errors, arg[2])
    correct_image_directory(errors, arg[3])
    right_csv_name(errors, arg[4])
    return errors

def correct_image_directory(errors, directory):
    '''
    Checks that the directory to images actually exists.
    '''
    if not directory.endswith("/"):
        directory += "/"
    if not os.path.isdir(directory):
        errors.append(directory + " not a correct directory!")

def correct_model_file(errors, filename):
    '''
    Checks that the path to trained model file is correct and that the model file is
    a .h5 file.
    '''
    if not os.path.isfile(filename):
        errors.append(filename + " not a correct path!")

    if not filename.endswith(".h5"):
        errors.append("File should be a .h5 file!")

def right_csv_name(errors, filename):
    '''
    Checks that the result file is a .csv-file and that it doesn't already exist.
    '''
    if not filename.endswith(".csv"):
        errors.append("Name of the file needs to end with .csv!")
        return False
    if os.path.isfile(filename):
        errors.append(filename + " file of this name already exists!")
        return False

    return True

def correct_number_of_arguments(errors, arg):
    '''
    Checks that the number of arguments is correct.
    '''
    if len(arg) < 5:
        errors.append("Too few arguments!")
        return False
    elif len(arg) > 5:
        errors.append("Too many arguments!")
        return False

    return True