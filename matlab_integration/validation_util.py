import os

errors = []

def get_errors(arg):
    correct_model_file(arg[1])
    correct_image_directory(arg[2])
    right_csv_name(arg[3])
    return errors

def correct_image_directory(directory):
    if not directory.endswith("/"):
        directory += "/"
    if not os.path.isdir(directory):
        #print(directory + "\n not a correct directory!")
        errors.append(directory + " not a correct directory!")
        return False

    return os.path.isdir(directory)
    #return os.path.isdir(directory) and directory.endswith("/")

def correct_model_file(filename):
    if not os.path.isfile(filename):
        #print(filename + "\n not a correct path!")
        errors.append(filename + " not a correct path!")
        return False

    if not filename.endswith(".h5"):
        #print("File should be a .h5 file!")
        errors.append("File should be a .h5 file!")
        return False

    return True


def existing_file(filename):
    return os.path.isfile(filename)

def right_csv_name(filename):
    if not filename.endswith(".csv"):
        #print("Name of the file needs to end with .csv!")
        errors.append("Name of the file needs to end with .csv!")
        return False
    #return filename.endswith(".csv") and not existing_file(filename)
    if existing_file(filename):
        #print(filename + " file of this name already exists!")
        errors.append(filename + " file of this name already exists!")
        return False

    return True