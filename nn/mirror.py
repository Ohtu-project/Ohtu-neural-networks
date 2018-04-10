from PIL import Image
import os

def _flip_x(image_path, saved_location):
    """
    Mirror the image in horizontal direction
 
    @param image_path: The path to the image to edit
    @param saved_location: Path to save the cropped image
    """
    image_obj = Image.open(image_path)
    rotated_image = image_obj.transpose(Image.FLIP_LEFT_RIGHT)
    rotated_image.save(saved_location)
    rotated_image.show()

def _flip_y(image_path, saved_location):
    """
    Mirror the image in vertical direction
 
    @param image_path: The path to the image to edit
    @param saved_location: Path to save the cropped image
    """
    image_obj = Image.open(image_path)
    rotated_image = image_obj.transpose(Image.FLIP_TOP_BOTTOM)
    rotated_image.save(saved_location)
    rotated_image.show()

# Read all images in directory:

# directory name
d = '/home/barimpac/keras-retinanet/data/imgs/train/'

files = os.listdir(d)

#to_save = '/home/barimpac/rotated/'

to_save = d

for f in files:
    fx = f.replace(".jpg", "x.jpg")
    fy = f.replace(".jpg", "y.jpg")

    _flip_x(d+f, to_save+fx)
    _flip_y(d+f, to_save+fy)
