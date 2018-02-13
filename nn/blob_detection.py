import numpy as np
import cv2 as cv
import matplotlib.pyplot as plt
import skimage.feature
import matplotlib.image as mpimg
import os

def GetData(filename, image):
    image_1 = image
    #image_1 = cv.GaussianBlur(image_1,(5,5),0)

    # convert to grayscale to be accepted by skimage.feature.blob_log
    image_6 = np.max(image_1,axis=2)

    #reverse colors
    image_6 = np.invert(image_6)

    
    blobs = skimage.feature.blob_log(image_6, min_sigma=35, max_sigma=100, num_sigma=1, threshold=0.1)

    print filename
    fig, ax = plt.subplots()
    ax.imshow(image_1, interpolation='none')
    ax.set_title('Laplacian of Gaussian')
    for blob in blobs:
        y, x, s = blob
        c = plt.Circle((x, y), s, color='yellow', linewidth=2, fill=False)
        ax.add_patch(c)
    plt.savefig('/home/matleino/Desktop/python/log_data/' + filename[:-4] + '_log.jpg')
    print filename + ' saved'


# Save all the images into directory
path = '/home/matleino/Desktop/python/blobs/'
files = os.listdir(path)

for i in files:
    if (".jpg" not in i):
        continue
    image = cv.imread(path + i)
    GetData(i, image)