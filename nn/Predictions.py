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
        image = read_image_bgr(image_path + img_name)
    
    # preprocess image for network
        image = preprocess_image(image)
        image, scale = resize_image(image)

    # process image
        print('shape: ' + str(np.expand_dims(image, axis=0).shape))
        _, _, boxes, classification = model.predict_on_batch(np.expand_dims(image, axis=0))

        print('boxes: ' + str(boxes))
        print('boxes.shape: ' + str(boxes.shape))
        print('classification: ' + str(classification))

    # compute predicted labels and scores
        predicted_labels = np.argmax(classification[0, :, :], axis=1)
        print(predicted_labels)
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

def ask_existing_directory(text):
    message = text
    directory = ""
    while not os.path.isdir(directory):
        directory = input(message)
        message = "There is no such directory. " + text
    if not directory.endswith('/'):
        directory += "/"
    return directory

def ask_existing_file(text):
    message = text
    filename = ""
    while not os.path.isfile(filename):
        filename = input(message)
        message = "There is no such file. " + text
    return filename

def ask_csv_filename(text):
    message = text
    filename = ""
    while True:
        filename = input(message)
        if not filename.endswith(".csv"):
            message = "File must be a csv file. " + text
        elif os.path.isfile(filename):
            message = "A file with given name already exists. " + text
        else:
            return filename


# use this environment flag to change which GPU to use
#os.environ["CUDA_VISIBLE_DEVICES"] = "1"

# set the modified tf session as backend in keras
keras.backend.tensorflow_backend.set_session(get_session())

trained_model_path = ask_existing_file("Give the model's path: ")
image_directory_path = ask_existing_directory("Give the directory containing images: ")
predictions_csv = ask_csv_filename("Give name to the csv file where predictions are saved: ")

save_prediction_to_csv(trained_model_path, image_directory_path, predictions_csv)
