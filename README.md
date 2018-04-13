# Software Engineering project -- Spring 2018
# Improving future Radiation Detectors with Neural Networks

###  Background
This software uses neural networks to process detector images, counting and classifying the defects it finds.

The motivation and full description of the project can be found [here](https://studies.cs.helsinki.fi/ohtuprojekti/topic_descriptions/201).

### Structure
`labelling_tools` contains tools to annotate the data manually, marking the position of the defects in the images, as well as classifying them. The Matlab software code is under `ClassLabelingTool`.
`generate_mirror_csv.m`converts the labels to csv format.

`nn` contains scripts to auxiliate training.

`matlab_integration` contains python scripts to get predictions over a set of images, and also matlab scripts that run the python scripts.

### Requirements

Our approach to detect defects bases currently on [keras-retinanet](https://github.com/fizyr/keras-retinanet). It uses Keras (2.1.3) on top of Tensorflow (1.5.0).

### Additional information

A detailed tutorial on submitting training to Ukko2 and using the labeling tool can be found [here](https://docs.google.com/document/d/1fL1QfdwUpIr44OGPi-63fFBI14bP9gQthvlQgvv_xEo/edit?usp=sharing).

Tutorials for using Ukko2 and labeling tool https://docs.google.com/document/d/1fL1QfdwUpIr44OGPi-63fFBI14bP9gQthvlQgvv_xEo/edit

[![Build Status](https://travis-ci.org/Ohtu-project/Ohtu-neural-networks.svg?branch=master)](https://travis-ci.org/Ohtu-project/Ohtu-neural-networks)
