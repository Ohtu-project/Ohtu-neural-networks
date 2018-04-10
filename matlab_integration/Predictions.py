import keras

# import keras_retinanet
from keras_retinanet.models.resnet import custom_objects
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image

# import miscellaneous modules
#import matplotlib.pyplot as plt
import cv2
import os
import numpy as np
import time
import glob

# set tf backend to allow memory to grow, instead of claiming everything
import tensorflow as tf

def get_session():
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.Session(config=config)

# use this environment flag to change which GPU to use
#os.environ["CUDA_VISIBLE_DEVICES"] = "1"

# set the modified tf session as backend in keras
keras.backend.tensorflow_backend.set_session(get_session())

TRAINED_MODEL_PATH = 'snapshots/'
TRAINED_MODEL_NAME = 'all_data1_66.h5'
IMAGE_DIRECTORY_PATH = 'data/imgs/test/subset/'

import pandas as pd

def save_prediction_to_csv():
    # adjust this to point to your downloaded/trained model
    model_path = os.path.join(TRAINED_MODEL_PATH, TRAINED_MODEL_NAME)

    # load retinanet model
    model = keras.models.load_model(model_path, custom_objects=custom_objects)
    #print(model.summary())

    # load label to names mapping for visualization purposes
    labels_to_names = {0: 'round_single', 1: 'round_double', 2: 'unclear_single', 3: 'unclear_double', 4: 'hexagonal_single', 5: 'square_single', 6: 'trigonal_single'}

    # Path of the directory containing the images that you would like to label.
    d = IMAGE_DIRECTORY_PATH

    # Make sure you have only images in this directory
    images = glob.glob(d + '/*.jpg')
    images.sort()

    labels = []

    for image in images:
        # load image
        path_separated = image.split("\\")
        print('path_separated: ' + str(path_separated))
        img_name = path_separated[len(path_separated) - 1]
        print('img_name: ' + img_name)
        image = read_image_bgr(d+img_name)
        #print(image)
    
    # preprocess image for network
        image = preprocess_image(image)
        image, scale = resize_image(image)

    # process image
        start = time.time()
        print('shape: ' + str(np.expand_dims(image, axis=0).shape))
        _, _, boxes, classification = model.predict_on_batch(np.expand_dims(image, axis=0))

        print("processing time: ", time.time() - start)
        print('boxes: ' + str(boxes))
        print('boxes.shape: ' + str(boxes.shape))
        print('classification: ' + str(classification))

    # compute predicted labels and scores
        predicted_labels = np.argmax(classification[0, :, :], axis=1)
        print(predicted_labels)
        scores = classification[0, np.arange(classification.shape[1]), predicted_labels]
    #print(scores)

    # correct for image scale
        boxes[0, :, :4] /= scale
    #print(boxes)

    # visualize boxes
        for idx, (label, score) in enumerate(zip(predicted_labels, scores)):
            if score < 0.5:
                continue
            b = boxes[0, idx, :4].astype(int)
            labels.append([img_name, b, labels_to_names[label]])

    df = pd.DataFrame(labels, columns=['image', 'defect coordinates', 'label'])

    # name of the file to save the predictions
    df.to_csv("class_test.csv")
    print("Done!")

save_prediction_to_csv()
