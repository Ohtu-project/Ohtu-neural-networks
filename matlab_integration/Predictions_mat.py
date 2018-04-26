'''
This script is intended to be called from Matlab, it uses the CPU instead of the GPU.
'''

import keras

# import keras_retinanet
from keras_retinanet.models.resnet import custom_objects
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image

# import miscellaneous modules
import cv2
import os
import numpy as np
import time
import glob
import pandas as pd
import sys

# set tf backend to allow memory to grow, instead of claiming everything
import tensorflow as tf

def get_session():
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.Session(config=config)

def save_prediction_to_csv(model_path, image_path, predictionfile):
    # load retinanet model
    model = keras.models.load_model(model_path, custom_objects=custom_objects)
    #print(model.summary())

    # Make sure you have only images in this directory
    images = glob.glob(image_path + '/*.jpg')
    images.sort()

    labels = get_labels_from_model(images, image_path, model)

    df = pd.DataFrame(labels, columns=['image', 'defect coordinates', 'label'])

    # name of the file to save the predictions
    df.to_csv(predictionfile)
    print("Done!")

def get_labels_from_model(images, image_path, model):
    labels = []

    # load label to names mapping for visualization purposes
    labels_to_names = {0: 'round_single', 1: 'round_double', 2: 'unclear_single', 3: 'unclear_double', 4: 'hexagonal_single', 5: 'square_single', 6: 'trigonal_single'}

    for image in images:
        # change image.split("/") to "\\" if used on windows
        path_separated = image.split("/")
        img_name = path_separated[len(path_separated) - 1]
        print(img_name)
        image = read_image_bgr(image_path + img_name)
    
    # preprocess image for network
        image = preprocess_image(image)
        image, scale = resize_image(image)

    # process image
        start = time.time()
        boxes, classification = model.predict_on_batch(np.expand_dims(image, axis=0))
        start = time.time()

    # compute predicted labels and scores
        predicted_labels = np.argmax(classification[0, :, :], axis=1)
        scores = classification[0, np.arange(classification.shape[1]), predicted_labels]

    # correct for image scale
        boxes[0, :, :4] /= scale

    # visualize boxes
        for idx, (label, score) in enumerate(zip(predicted_labels, scores)):
            if score < 0.5:
                continue
            b = boxes[0, idx, :4].astype(int)
            labels.append([img_name, b, labels_to_names[label]])
    
    return labels

def existing_directory(directory):
    if not directory.endswith("/"):
        directory += "/"
    if not os.path.isdir(directory):
        print(directory + "\n not a correct directory!")
        return False

    return os.path.isdir(directory)
    #return os.path.isdir(directory) and directory.endswith("/")

def correct_model_file(filename):
    if not os.path.isfile(filename):
        print(filename + "\n not a correct path!")
        return False

    if not filename.endswith(".h5"):
        print("File should be a .h5 file!")
        return False

    return True


def existing_file(filename):
    return os.path.isfile(filename)

def right_csv_name(filename):
    if not filename.endswith(".csv"):
        print("Name of the file needs to end with .csv!")
        return False
    #return filename.endswith(".csv") and not existing_file(filename)
    if existing_file(filename):
        print(filename + " file of this name already exists!")
        return False

    return True

def right_arguments(arg):
    if len(arg) < 4:
        return False
    #elif not existing_file(arg[1]) or not existing_directory(arg[2]) or not right_csv_name(arg[3]):
    elif not correct_model_file(arg[1]) or not existing_directory(arg[2]) or not right_csv_name(arg[3]):
        return False
    return True


def main(arg):
    # set the modified tf session as backend in keras
    keras.backend.tensorflow_backend.set_session(get_session())

    if right_arguments(arg):
        [a, trained_model_path, image_directory_path, predictions_csv] = arg
        save_prediction_to_csv(trained_model_path, image_directory_path, predictions_csv)
    else:
        print("Given arguments are wrong.")


if __name__ == "__main__":
    main(sys.argv)
