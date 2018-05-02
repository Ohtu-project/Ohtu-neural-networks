from PIL import Image
import sys
import os
import glob

def _flip_x(image_path, saved_location):
    """
    Mirror the image in horizontal direction
 
    @param image_path: The path to the image to edit
    @param saved_location: Path to save the mirrored image
    """
    image_obj = Image.open(image_path)
    rotated_image = image_obj.transpose(Image.FLIP_LEFT_RIGHT)
    rotated_image.save(saved_location)

def _flip_y(image_path, saved_location):
    """
    Mirror the image in vertical direction
 
    @param image_path: The path to the image to edit
    @param saved_location: Path to save the mirrored image
    """
    image_obj = Image.open(image_path)
    rotated_image = image_obj.transpose(Image.FLIP_TOP_BOTTOM)
    rotated_image.save(saved_location)

def ask_directory(text):
    message = text
    directory = ""
    while not os.path.isdir(directory):
        if sys.version_info.major == 2:
            directory = raw_input(message)
        else:
            directory = input(message)
        message = "There is no such directory. " + text
    if not directory.endswith('/'):
        directory += "/"
    return directory


def main(arg):
    d = ask_directory("Give the directory containing images you want to mirror: ")

    files = os.listdir(d)
    images = glob.glob(d + '/*.jpg')

    to_save = ask_directory("Give the directory where you want the mirrored images to be saved: ")


    for image in images:
        path_separated = image.split("/")
        img_name = path_separated[len(path_separated) - 1]
        fx = img_name.replace(".jpg", "x.jpg")
        fy = img_name.replace(".jpg", "y.jpg")
        fxy = img_name.replace(".jpg", "xy.jpg")

        _flip_x(d+img_name, to_save+fx)
        _flip_y(d+img_name, to_save+fy)
        _flip_y(to_save+fx, to_save+fxy)

if __name__ == "__main__":
    main(sys.argv)