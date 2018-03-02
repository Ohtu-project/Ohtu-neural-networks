## Ukko2 setup
## Author: Vitoria Barin Pacela
## vitoria.barinpacela@helsinki.fi
## 02.03.2018

#!/bin/bash 

# Loading necessary modules
module load Python/3.6.2-foss-2017b
module load cuDNN/7.0.5-CUDA-9.1.85

# Creating a virtual environment
virtualenv myTensorflow
source myTensorflow/bin/activate

# Installing dependencies into the environment
pip install tensorflow
pip install tensorflow-gpu
pip install keras

# Setting-up keras-retinanet
git clone https://github.com/fizyr/keras-retinanet.git

pip install 'numpy>=1.14'
pip install 'keras==2.1.3'
pip install 'opencv-python>=3.3.0'
pip install 'pillow'
pip install 'git+https://github.com/broadinstitute/keras-resnet'
pip install 'pytest-pep8'
pip install 'cython'
pip install 'matplotlib'
pip install 'h5py'
