'''
This script is meant to be submitted to Ukko2, since it requires GPU usage.
'''

import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../..')))

import setGPU
import keras


# import keras_retinanet
from keras_retinanet import models
from keras_retinanet.utils.image import read_image_bgr, preprocess_image, resize_image
from keras_retinanet.utils.visualization import draw_box, draw_caption
from keras_retinanet.utils.colors import label_color

# import miscellaneous modules
import cv2
#import os
import numpy as np
import time
import glob
import pandas as pd
#import sys
from utils.validation_util import get_errors

# set tf backend to allow memory to grow, instead of claiming everything
import tensorflow as tf

def get_session():
    config = tf.ConfigProto()
    config.gpu_options.allow_growth = True
    return tf.Session(config=config)

def save_prediction_to_csv(model_path, read_image_path, save_image_path, predictionfile):
    # load retinanet model
    model = models.load_model(model_path, backbone_name='resnet50')
    print(model.summary())

    # Make sure you have only images in this directory
    images = glob.glob(read_image_path + '/*.jpg')
    images.sort()

    labels = get_labels_from_model(images, read_image_path, save_image_path, model)

    df = pd.DataFrame(labels, columns=['image', 'defect coordinates', 'label'])

    # name of the file to save the predictions
    df.to_csv(predictionfile)
    print('Done!')

def get_labels_from_model(images, read_image_path, save_image_path, model):
    Labels = []

    # load label to names mapping for visualization purposes
    labels_to_names = {0: 'round_single', 1: 'round_double', 2: 'unclear_single', 3: 'unclear_double', 4: 'hexagonal_single', 5: 'square_single', 6: 'trigonal_single', 7: 'void_single', 8: 'bubbles_single'}

    for image in images:
        # change image.split("/") to "\\" if used on windows
        path_separated = image.split("/")
        image_name = path_separated[len(path_separated) - 1]
        print(image_name)
        image = read_image_bgr(read_image_path + image_name)
    
    # copy to draw on
        draw = image.copy()
        draw = cv2.cvtColor(draw, cv2.COLOR_BGR2RGB)    

    # preprocess image for network
        image = preprocess_image(image)
        print('image preprocessed')
        image, scale = resize_image(image)

    # process image
        start = time.time()
        boxes, scores, labels = model.predict_on_batch(np.expand_dims(image, axis=0))
        print('processing time: ', time.time() - start)

    # correct for image scale
        boxes /= scale

    # visualize boxes and store annotations to array Labels
        for idx, (box, score, label) in enumerate(zip(boxes[0], scores[0], labels[0])):
            if score < 0.5:
                continue
            b = boxes[0, idx, :4].astype(int)

            Labels.append([image_name, b, labels_to_names[label]])

            color = label_color(label)
            draw_box(draw, b, color=color)
            
            caption = "{} {:.3f}".format(labels_to_names[label], score)
            draw_caption(draw, b, caption)

        save_image_name = image_name.split(".")[0] + '_pred'
        cv2.imwrite(os.path.join(save_image_path, '{}.jpg'.format(save_image_name)), draw)
        
    return Labels


def main(arg):
    # set the modified tf session as backend in keras
    keras.backend.tensorflow_backend.set_session(get_session())

    # make image save path if it doesn't exist
    if arg[3] is not None and not os.path.exists(arg[3]):
        os.makedirs(arg[3])

    errors = get_errors(arg)
    # check that there are no errors in the given arguments
    if not errors:
        [a, trained_model_path, read_image_directory_path, save_image_directory_path, predictions_csv] = arg
        save_prediction_to_csv(trained_model_path, read_image_directory_path, save_image_directory_path, predictions_csv)
    else:
        print('Given arguments are wrong:')
    for error in errors: print(error)

if __name__ == "__main__":
    main(sys.argv)
