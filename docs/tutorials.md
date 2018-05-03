# Tutorials

## How to use the labeling tool

Run the file `labeling_tool_main.m`.
First the program asks a folder. Give a path to a folder, which contains the images you want to label.

### Output: 
The program creates a file `LABELS.csv` inside the folder containing the images.
If some of the images in the folder have already been labeled when running the program (and labels are in a file ‘LABELS.csv’), the program will ask if you want to label all the images again, or continue from the first non-labeled image. If first the option if chosen, all previously labeled data is deleted. If the second option is chosen, previously labeled data is saved in file 'LABELS.csv' and new data is added to this file.

### How to label: 
When an image is shown, you can mark a defect by clicking on any two opposite corners of the defect. A box is drawn  around the defect.
You can change the classes by clicking the options on the right side of the image. The chosen classes are shown in yellow colour. The class can be chosen only when a red box is shown.
If you want to mark multiple defects in one image, just click the corners of the next defect and choose classes like before. No buttons need to be clicked between defects. If you make a mistake, you can reverse clicked points with the ‘undo’ button. When you want to move on to the next image, click the ‘done’ button.
You cannot go back to a previous image by using ‘undo’, you can only remove marked points with it.


## How to use the Matlab integration
Below are instructions on how you can use a pretrained neural network model to evaluate a set of images on your personal computer.

First, install Matlab if you don't have it yet.

Install [Miniconda](https://conda.io/miniconda.html). Conda is a package manager and a minimal version of Anaconda that contains Python 3.6. You also need to install [TensorFlow](https://www.tensorflow.org/install/) on your computer. Use [the instructions for installing with Anaconda](https://www.tensorflow.org/install/install_linux#InstallingAnaconda) to create a tensorflow environment.

You should do the following steps inside a tensorflow environment:
* Install [Git](https://git-scm.com/) inside the environment.

* Clone this repository with `git clone https://github.com/Ohtu-project/Ohtu-neural-networks.git`

* Follow the instructions below to install [Keras RetinaNet](https://github.com/fizyr/keras-retinanet), which is the open source neural network that we are using for this project. Tensorflow is the backend that Keras uses.

You should install Keras RetinaNet in the same `matlab_integration` folder where `defect_detector.m` and `Predictions_mat.py` files are. Use the command line to get in the matlab_integration folder and then you can install RetinaNet through git with the following commands:

`git clone https://github.com/fizyr/keras-retinanet.git`  
`cd keras-retinanet`  
`pip install . --user`  
`pip install --user --upgrade git+https://github.com/broadinstitute/keras-resnet`  

The keras-retinanet version that is guarateed to work with our software can be retrieved by:
`git reset --hard 84c6dcf8c243f0baaf03bd4dfdf8c824edfd3730`
(commit from May 1 2018)

Then keras-retinanet should be ready for use.

* Follow screen instructions and add new paths to $PATH variables to get rid of path warnings

* You might need to install following packages if they are missing: opencv, Pillow, pandas

Now you can use the defect_detector function inside defect_detector.m to evaluate images.

`defect_detector.m` has only one function, called `defect_detector`, with four parameters. More documentation on the function can be found in the `defect_detector.m` file itself.

`defect_detector.m` can be moved from the matlab_integration folder to be used as a part of any matlab-project. The parameters given to the function are used to find the `Predictions_mat.py` file.

Put the images that you want to use inside matlab_integration/images. It shouldn't contain any subfolders, just the jpg files of the images.

If you are using Windows instead of Unix, modify the `Predictions_mat.py` script so that the paths contain "\\" instead of "/".

It currently takes about 7 seconds to find the defects in a single picture on a laptop.

Lastly, here is an example of parameters to use in the `defect_detector` function:

`path = '/home/matleino/Ohtu-neural-networks/matlab_integration/'`  
`trained_model_path = '/home/matleino/Ohtu-neural-networks/matlab_integration/trained-model/resnet50_csv_68.h5'`  
`image_directory_path = '/home/matleino/Ohtu-neural-networks/matlab_integration/images/'`  
`csv_file = 'results.csv'`  

`defect_detector(path, trained_model_path, image_directory_path, csv_file)`

## How to run code in your local computer

Use it only to generate predictions and evaluations, do not train anything locally!

We assume that you have already gone through the basic installation steps described in "How to use the Matlab integration" and have keras-retinanet working.

### How to evaluate a model from your local computer
To get the defect predictions over a set of pictures, run, from the keras-retinanet directory:
`keras_retinanet/bin/evaluate.py --save-path <path> csv test_annotation_multi.csv class_mapping_multi.csv <model weights file>`
In which <path> is the path where you want to save your images, for example ~/mirrored_more/
And `<model weights file>` is, for example, snapshots/resnet50_csv_68.h5

## How to set up Ukko2 for the first use
If you are not familiar with Ukko2, please read the [user guide](https://wiki.helsinki.fi/display/it4sci/Ukko2+User+Guide)

To access it, use `ssh ukko2.cs.helsinki.fi`
You have to be in the university network (use some school computer). If you want to use it from your laptop, additional steps are required for all the funcionalities, please contact Vitória.

### (Optional) Tmux
Before anything, I highly recommend initiating a tmux session: it keeps your processes running regardless of connection issues, and it enables you to keep many windows open in tmux. You can start it with:
`tmux` 
Here’s a [cheat sheet] (https://www.tmuxcheatsheet.com/).
Useful commands are `Ctrl+B S` to change windows, and `Ctrl+B :new` to open a new window.
`tmux ls` displays all your sessions


### (Optional) Anaconda and Jupyter
Second, you may want to install Anaconda (for example if you want to use Jupyter Notebooks), but it’s not a requirement.
To use Jupyter Notebook (or Jupyter Lab) in Ukko2, launch it with
`jupyter lab --no-browser --port=8889`
Then in your local computer, run
`ssh -N -f -L localhost:8889:localhost:8889 <username>@ukko2.cs.helsinki.fi`
Finally, you can launch jupyter from your browser with `localhost:8889`.


### Setup
Clone our Ohtu repository in your home directory with `git clone https://github.com/Ohtu-project/Ohtu-neural-networks.git`.

At `Ohtu-neural-networks/nn/` you can find `train`, `test`, `pred`, `Predictions_ukko.py`, and `ukko2_setup.sh` scripts.

Grant executing rights
`chmod +x ./ukko2_setup.sh`

Run:
`./ukko2_setup.sh`

It will clone the retinanet repository, create a virtual environment called `myTensorflow` and install all the necessary dependencies.


### Necessary files
Copy the file containing the labels you wish to train on in keras-retinanet/.

From Ohtu-neural-networks/nn/, copy `train`, `test`, and `pred` into keras-retinanet/.

Modify `pred` so that it finds the csv files. Alternatively, from Ohtu-neural-networks/csv/, copy `class_mapping_multi.csv` and `test_annotation_multi.csv` into keras-retinanet/.


### Training for the first time
Still inside keras-retinanet, create a directory containing the images for training. The directory structure must be the same as in the labels.csv file. In my case, I have: 
keras-retinanet/imgs/train/
and then the Acrorad images.

You need to transfer all the images you are going to label for training, which must be the same as in the `train_annotations_classes.csv` file.


### (Optional) How to transfer files
(*) To copy the images and labels to Ukko2, you can either use scp, or mount Ukko2 in your computer.

Use the following commands from your local computer, not from ukko2.

`scp <path to file>/file <username>@ukko2.cs.helsinki.fi:/home/<username>/<path to folder where you want to paste it>`

For a directory:
`scp -r <path to your folder of images> ukko2.cs.helsinki.fi:/home/matleino/`
To transfer them back to your computer:
`scp -r ukko2.cs.helsinki.fi:/home/matleino/<name of the folder> ~/Downloads`
(if you want to copy them into Downloads)

Alternatively, to mount Ukko2 in an Ubuntu computer, go to a file explorer, then File -> Connect to Server…
Server: ukko2.cs.helsinki.fi
Type: SSH
Folder: /home/<username>


### (Training) Rotating images
To generate rotated images, python mirror.py from Ohtu-neural-networks/nn/. The script produces images with the same image names, followed by “_x” or “_y”.
You may need to change the path to the images to mirror.


### (Training) Rotating labels
Remember to transfer to Ukko2 the csv file containing the labels referring to the images.

To generate another csv file containing rotated labels, execute `generate_mirror_csv.m` from 
Ohtu-neural-networks/labelling_tools/. This script allow you also add relative paths to images as the first column of the generated csv file, so that the networks finds the images labeled. 


### (Training) Submit job to Ukko2
To train a model in Ukko2, change the train script:
Point `--snapshot-path` to the path where you want to save your models, I suggest `keras-retinanet/snapshots/<folder name>/`. 
Make sure to change the `--steps` parameter to the number of lines you have in the csv file containing the annotations. We can also see how to implement to do it automatically in the future.
Point `--weights` to the model path.


To submit the training, use the following command:
`sbatch train`

After you finish the training job, please copy the .h5 file containing the latest model to your computer and update it to the Drive with some descriptive name.


### (Optional) Useful commands

To check the status of your jobs, use:
`squeue -u <username>`
(your username there)

To check what your process has been printing, use:
`tail -f train_class.out`
(or whatever you had as your output file in the train script)

To cancel your job:
`scancel <id>`
(in which `<id>` is your process id, which you could see by using the squeue command mentioned before)


### Testing

This script is going to generate test images containing plotted boxes for the labeled defects, and the predicted defects.

First, make sure that you have the `test_annotation_multi.csv` file, so as the test images. The file structure must be the same as indicated in the csv file (data/imgs/test/)

After that, you can
`sbatch test`
to see how your model evaluates the test set. A folder will be created in ~/results (or in any other path you wish), containing the image predictions.

	
### Running Predictions

To get the predictions for some crystal, first copy the data to be predicted.
Change the pred script so that it has the parameters you desire, for example the path to the folder containing the images.
Then run the pred script, which basically executes Predictions.py.


## How to submit training to Ukko after the first time
Follow the previous tutorial from the star (*).

If you have problems, try to execute the following commands:
`module purge`
`module load Python cuDNN`

Activate the virtual environment with
`source ~/myTensorflow/bin/activate`


If you still have errors using sbatch, you can start an interactive session by executing:
`srun -c 1 --gres=gpu:1 -p gpu -t5-0 --mem-per-cpu=1000 --pty bash`
`module purge`
`module load Python cuDNN`
`source ~/myTensorflow/bin/activate`
Then just run bash commands normally.
The command allocates the gpu for five days (-t5-0), so remember to cancel your job when it finishes.

