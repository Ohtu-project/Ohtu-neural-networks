import keras

# import keras_retinanet
import keras_retinanet.models.resnet.custom_objects
import keras_retinanet.utils.image.read_image_bgr
import keras_retinanet.utils.image.preprocess_image
import keras_retinanet.utils.image.resize_image

# import miscellaneous modules
import os
import sys
import numpy as np
import time
import pandas as pd

# set tf backend to allow memory to grow, instead of claiming everything
#import tensorflow as tf

#def get_session():
#    config = tf.ConfigProto()
#    config.gpu_options.allow_growth = True
#    return tf.Session(config=config)

# use this environment flag to change which GPU to use
#os.environ["CUDA_VISIBLE_DEVICES"] = "1"

# set the modified tf session as backend in keras
#keras.backend.tensorflow_backend.set_session(get_session())

TRAINED_MODEL_PATH = '/home/barimpac/Documents/Ohtu-neural-networks/matlab_integration/snapshots/'
TRAINED_MODEL_NAME = 'resnet50_csv_68.h5'
IMAGE_DIRECTORY_PATH = '/home/barimpac/Documents/Ohtu-neural-networks/matlab_integration/images/'

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

save_prediction_to_csv()
