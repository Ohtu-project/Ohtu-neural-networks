path = '/home/matleino/Ohtu-neural-networks/matlab_integration/'
trained_model_path = '/home/matleino/Ohtu-neural-networks/matlab_integration/trained-model/resnet50_csv_50_13april2018_fixed.h5'
%trained_model_file = 'resnet50_csv_50.h5'
image_directory_path = '/home/matleino/Ohtu-neural-networks/matlab_integration/images/'
csv_file = 'results.csv'

defect_detector(path, trained_model_path, image_directory_path, csv_file)
