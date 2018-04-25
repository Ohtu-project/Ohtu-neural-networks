#!/bin/bash
#SBATCH --job-name=train
#SBATCH -c 2
#SBATCH --gres=gpu:1
#SBATCH -p gpu
#SBATCH -t 7-0
#SBATCH --mem-per-cpu=100G
#SBATCH --output train_class.out

module purge
module load Python cuDNN
# Whatever additional modules you need
source ~/myTensorflow/bin/activate
 
#Executable here
keras_retinanet/bin/train.py --gpu 2 --epochs 50 --weights /home/barimpac/keras-retinanet/snapshots/resubmit/resnet50_csv_34.h5 --snapshot-path /home/barimpac/keras-retinanet/snapshots/squares/ --steps 1473 csv DT_square_train.csv csv/class_mapping_multi.csv
