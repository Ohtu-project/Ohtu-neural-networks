import keras

# import keras_retinanet
from keras_retinanet.models.resnet import custom_objects
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image

# import miscellaneous modules
import cv2
import os
import sys
import numpy as np
import time
import pandas as pd

# set tf backend to allow memory to grow, instead of claiming everything
import tensorflow as tf

# use this environment flag to change which GPU to use
os.environ["CUDA_VISIBLE_DEVICES"] = "1"

# set the modified tf session as backend in keras
def get_session():
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.Session(config=config)

keras.backend.tensorflow_backend.set_session(get_session())

def get_model(trained_model_path, trained_model_name):
    model_path = os.path.join(trained_model_path, trained_model_name)
    model = keras.models.load_model(model_path, custom_objects=custom_objects)
    return model

def image_preprocessing(image):
    # preprocess image for network
    image = preprocess_image(image)
    image, scale = resize_image(image)
    return (image, scale)

# This main function uses Keras RetinaNet to recognise defects in images.
def main(argv):
    sys.argv[0]
    TRAINED_MODEL_PATH = sys.argv[1]
    TRAINED_MODEL_NAME = sys.argv[2]
    IMAGE_DIRECTORY_PATH = sys.argv[3]

    # load retinanet model
    #print(model.summary())
    model = get_model(TRAINED_MODEL_PATH, TRAINED_MODEL_NAME)

    # load label to names mapping for visualization purposes
    labels_to_names = {0: 'defect'}

    images = os.listdir(IMAGE_DIRECTORY_PATH)

    defect_labels = []

    for image in images:
        # load image
        img_name = image
        #image = read_image_bgr(d+image)
        image = read_image_bgr(IMAGE_DIRECTORY_PATH + image)
    
        # preprocess image for network
        image, scale = image_preprocessing(image)

        # process image
        start = time.time()
        _, _, detections = model.predict_on_batch(np.expand_dims(image, axis=0))
        print("processing time: ", time.time() - start)

        # compute predicted labels and scores
        predicted_labels = np.argmax(detections[0, :, 4:], axis=1)
        scores = detections[0, np.arange(detections.shape[1]), 4 + predicted_labels]

        # correct for image scale
        detections[0, :, :4] /= scale

        # visualize detections
        for idx, (label, score) in enumerate(zip(predicted_labels, scores)):
            if score < 0.5:
                continue
            b = detections[0, idx, :4].astype(int)
            defect_labels.append([img_name, b])

    df = pd.DataFrame(defect_labels, columns=['image', 'defect coordinates'])

    # name of the file to save the predictions
    df.to_csv("results.csv")

if __name__ == "__main__":
   main(sys.argv[1:])