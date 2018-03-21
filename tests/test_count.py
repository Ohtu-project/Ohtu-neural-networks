import unittest
import os, sys

#if __package__ is None:
sys.path.append("../matlab_integration/")

from count_defects import *

#def test_main():
#	count_defects.main(csvFile='test-data/test1.csv')

class TestBasicFunction(unittest.TestCase):

#    def test_main():
#        count_defects.main(csvFile='test-data/test1.csv')

    def test_counting_right_short_list(self):
        defect_labels = [
          ['', 'image', 'defect coordinates'],
          ['0', 'Acrorad_0712-1001-1-07-01028.jpg', '[ 970  741 1012  792]']
        ]

        self.assertEqual(countDefects(defect_labels, 1028), [['Acrorad_0712-1001-1-07-01028.jpg', 1]])
 
    def test_counting_right_longer_list(self):
        defect_labels = [
          ['', 'image', 'defect coordinates'],
          ['0', 'Acrorad_0712-1001-1-07-01028.jpg', '[ 970  741 1012  792]'],
          ['1', 'Acrorad_0712-1001-1-07-01029.jpg', '[ 53  89 181 204]'],
          ['2', 'Acrorad_0712-1001-1-07-01030.jpg', '[1022  530 1176  673]'],
          ['3', 'Acrorad_0712-1001-1-07-01031.jpg', '[1022  517 1085  587]'],
          ['4', 'Acrorad_0712-1001-1-07-01031.jpg', '[1054  245 1169  368]'],
          ['5', 'Acrorad_0712-1001-1-07-01033.jpg', '[308 446 388 518]'],
          ['6', 'Acrorad_0712-1001-1-07-01034.jpg', '[571  65 631 128]'],
          ['7', 'Acrorad_0712-1001-1-07-01035.jpg', '[ 996  330 1125  448]'],
          ['8', 'Acrorad_0712-1001-1-07-01035.jpg', '[1169   12 1277  117]']
        ]

        expected_ouput = [
          ['Acrorad_0712-1001-1-07-01028.jpg', 1],
          ['Acrorad_0712-1001-1-07-01029.jpg', 1],
          ['Acrorad_0712-1001-1-07-01030.jpg', 1],
          ['Acrorad_0712-1001-1-07-01031.jpg', 2],
          ['Acrorad_0712-1001-1-07-01032.jpg', 0],
          ['Acrorad_0712-1001-1-07-01033.jpg', 1],
          ['Acrorad_0712-1001-1-07-01034.jpg', 1],
          ['Acrorad_0712-1001-1-07-01035.jpg', 2]          
        ]

        self.assertEqual(countDefects(defect_labels, 1035), expected_ouput)

if __name__ == '__main__':
    unittest.main()
