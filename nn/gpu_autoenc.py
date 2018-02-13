from keras.layers import Input, Dense
from keras.models import Model
import numpy as np
import os
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from keras.callbacks import EarlyStopping, ModelCheckpoint
import h5py

os.environ['KERAS_BACKEND'] = 'tensorflow'
os.environ['CUDA_VISIBLE_DEVICES'] = '1'

def loadModel(name, weights = False):
    json_file = open('%s.json' % name, 'r')
    loadedmodeljson = json_file.read()
    json_file.close()
    
    model = model_from_json(loadedmodeljson)
    
    #load weights into new model
    if weights == True:
        model.load_weights('%s.h5' % name)
    #print model.summary()
    
    print("Loaded model from disk")
    return model


def saveModel(model, name = "dnn"):
    model_name = name
    model.summary()
    model.save_weights('%s.h5' % model_name, overwrite=True)
    model_json = model.to_json()
    with open("%s.json" % model_name, "w") as json_file:
        json_file.write(model_json)
        
def saveLosses(hist, name="dnn"):    
    loss = np.array(hist.history['loss'])
    valoss = np.array(hist.history['val_loss'])
    
    f = h5py.File("%s_losses.h5" % name, "w")
    f.create_dataset('loss', data=loss)
    f.create_dataset('val_loss', data=valoss)
    f.close()

## Model
def initAutoencoderModel(encoding_dim, image_dim):
    # this is the size of our encoded representations
    encoding_dim = encoding_dim  # 32 floats -> compression of factor 24.5, assuming the input is 784 floats

    # this is our input placeholder
    input_img = Input(shape=(image_dim,))
    # "encoded" is the encoded representation of the input
    encoded = Dense(encoding_dim, activation='relu')(input_img)
    # "decoded" is the lossy reconstruction of the input
    decoded = Dense(image_dim, activation='sigmoid')(encoded)

    # this model maps an input to its reconstruction
    autoencoder = Model(input_img, decoded)

    encoder = Model(input_img, encoded)

    # create a placeholder for an encoded (32-dimensional) input
    encoded_input = Input(shape=(encoding_dim,))
    # retrieve the last layer of the autoencoder model
    decoder_layer = autoencoder.layers[-1]
    # create the decoder model
    decoder = Model(encoded_input, decoder_layer(encoded_input))

    autoencoder.compile(optimizer='adadelta', loss='binary_crossentropy')

    saveModel(autoencoder)

    return autoencoder

## Getting data
def getData(d):
    #d = '/cs/work/home/barimpac/NN/Neural Network Trainung Data/Defect training/'
    files = os.listdir(d)
    inp = []

    for i in files:
        if (".jpg" not in i):
            continue
        img=mpimg.imread(d+i)
        inp.append(img)
    inp = np.asarray(inp)

    norm = inp.astype('float32') / 255.

    norm = norm.reshape((len(norm), np.prod(norm.shape[1:])))

    train = norm[0:36]

    val = norm[37:73]

    return train, val


autoencoder = initAutoencoderModel(100, 1310720)
train, val = getData('/cs/work/home/barimpac/NN/Neural Network Trainung Data/Defect training/')

hist = autoencoder.fit(train, train,
                epochs=50,
                batch_size=256,
                shuffle=True,
                validation_data=(val, val),
		callbacks=[EarlyStopping(monitor='val_loss', patience=5, verbose=1, mode='min'),
		ModelCheckpoint(filepath='/cs/work/home/barimpac/autoencoder.h5', verbose=0)])

saveLosses(hist, name='autoenc')
