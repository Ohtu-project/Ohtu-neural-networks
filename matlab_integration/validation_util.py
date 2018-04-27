import os

def correct_image_directory(errors, directory):
    if not directory.endswith("/"):
        directory += "/"
    if not os.path.isdir(directory):
        errors.append(directory + " not a correct directory!")
        return False

    return os.path.isdir(directory)

def correct_model_file(errors, filename):
    if not os.path.isfile(filename):
        errors.append(filename + " not a correct path!")
        return False

    if not filename.endswith(".h5"):
        errors.append("File should be a .h5 file!")
        return False

    return True


def existing_file(filename):
    return os.path.isfile(filename)

def right_csv_name(errors, filename):
    if not filename.endswith(".csv"):
        errors.append("Name of the file needs to end with .csv!")
        return False
    if existing_file(filename):
        errors.append(filename + " file of this name already exists!")
        return False

    return True

def correct_number_of_arguments(errors, arg):
    if len(arg) < 4:
        errors.append("Too few arguments!")
        return False
    elif len(arg) > 4:
        errors.append("Too many arguments!")
        return False

    return True


def get_errors(arg):
    errors = []
    if not correct_number_of_arguments(errors, arg):
        return errors

    correct_model_file(errors, arg[1])
    correct_image_directory(errors, arg[2])
    right_csv_name(errors, arg[3])
    return errors