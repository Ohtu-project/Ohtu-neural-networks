## Expects first_image_name to be in 'Acrorad_0712-1001-1-07-01028.jpg'-like format
def count_defects (defect_labels, first_image_name, last_image_number):
    defect_counts = []
    
    ## With different images modifications for next 3 lines are required    
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

## Expects first_image_name to be in 'Acrorad_0712-1001-1-07-01028.jpg'-like format
def next_image_name(image_name):
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