import csv

def next_image_name(image_name):
    '''
    Returns the name of the next image.
    Expects first_image_name to be in 'Acrorad_0712-1001-1-07-01028.jpg'-like format
    :param image_name: (str) name of the current image.
    :return: (str) name of the next image.
    '''
    name = image_name.split('.')[0]
    ending = image_name.split('.')[1]
    number = int(name[-4:])
    next_number = number + 1

    if next_number < 10:
        str_number = '000' + str(next_number)
    elif next_number < 100:
        str_number = '00' + str(next_number)
    elif next_number < 1000:
        str_number = '0' + str(next_number) 
    else:
        str_number = str(next_number)
    
    return name[:-4] + str_number + '.' + ending


def countDefects (defect_labels, last_image_number):
    '''
    Returns a list containing the number of defects in each image.
    Expects first_image_name to be in 'Acrorad_0712-1001-1-07-01028.jpg'-like format
    To implement: Get last_image_number directly from defect_labels.
    :param defect_labels: (list[str]) contains the image name in the second column, and the defect coordinates in the
    third column.
    :param last_image_number: (int) four-digit number at the end of the name of the last image from the list.
    :return: (list)
    '''
    first_image_name = defect_labels[1][1] # first image in the defect_labels list

    defect_counts = []

    # takes off the .jpg part of the name of the image
    # and gets the four last digits of the such string
    image_number = int(first_image_name.split('.')[0][-4:])
    image_name = first_image_name
    
    row_number = 1
    count = 0
    
    while image_number <= last_image_number:        
        if row_number == len(defect_labels):
            defect_counts.append([image_name, 0])
        elif not defect_labels[row_number][1] == image_name:
            defect_counts.append([image_name, 0])
        else:
            while defect_labels[row_number][1] == image_name:
                if 'square' not in defect_labels[row_number][-1]:
                    count += 1
                row_number += 1
                ## to avoid IndexError
                if row_number == len(defect_labels):
                    break
            defect_counts.append([image_name, count])
            count = 0
            
        image_number += 1
        image_name = next_image_name(image_name)   
            
    return defect_counts


def getDefectLabels(file_name):
    '''
    Opens .csv file containing the defect coordinates and loads it in a list.
    :param file_name: (str) name of the csv file (or the path to it), must contain .csv ending.
    :return: (list) defect labels. Returns None if file_name not in correct format.
    '''
    if (file_name.endswith('.csv') | file_name.endswith('.csv/')):
        with open(file_name, 'rt') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
    
            defect_labels = []
            for row in reader:
                defect_labels.append(row)

        return defect_labels
    raise TypeError('Name of the file needs to end with .csv!')

    


def saveCount(defCount, nameToSave):
    '''
    Saves a .csv file containing the name of the image in the first column, and the number of defects in the second
    column.
    To implement: check that nameToSave not in any other file-format like .txt.
    :param nameToSave: (str) name of the csv file to be saved, containing .csv ending.
    '''
    if (not nameToSave.endswith('.csv')):
        nameToSave += '.csv'

    with open(nameToSave, 'wt', newline='') as csvfile:
        writer = csv.writer(csvfile)
    
        #Write headers
        writer.writerow(['image', 'amount of defects'])

        #Write content
        for row in defCount:
           # print(row)
            writer.writerow(row)


# Change the label name, image name and number for different images
# To implement: give those as arguments to parse
def main(csvFile='test1.csv', lastNum=1098, toSave='test1-defect_count.csv'):
	defect_labels = getDefectLabels(csvFile)
	defect_counts = countDefects(defect_labels, lastNum)
	saveCount(defect_counts, toSave)

if __name__ == "__main__":
    main()




