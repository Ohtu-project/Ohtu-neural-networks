from __future__ import absolute_import

import unittest
import os, sys

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from matlab_integration import count_defects

class TestBasicFunction(unittest.TestCase):

    def test_counting_right_short_list(self):
        defect_labels = [
          ['', 'image', 'defect coordinates', 'class'],
          ['0', 'Acrorad_0712-1001-1-07-01028.jpg', '[ 970  741 1012  792]', 'round_single']
        ]

        self.assertEqual(count_defects.countDefects(defect_labels, 1028), [['Acrorad_0712-1001-1-07-01028.jpg', 1]])
 
    def test_counting_right_longer_list(self):
        defect_labels = [
          ['', 'image', 'defect coordinates', 'class'],
          ['0', 'Acrorad_0712-1001-1-07-01028.jpg', '[ 970  741 1012  792]', 'round_single'],
          ['1', 'Acrorad_0712-1001-1-07-01029.jpg', '[ 53  89 181 204]', 'unclear_single'],
          ['2', 'Acrorad_0712-1001-1-07-01030.jpg', '[1022  530 1176  673]', 'round_double'],
          ['3', 'Acrorad_0712-1001-1-07-01031.jpg', '[1022  517 1085  587]', 'round_single'],
          ['4', 'Acrorad_0712-1001-1-07-01031.jpg', '[1054  245 1169  368]', 'round_single'],
          ['5', 'Acrorad_0712-1001-1-07-01033.jpg', '[308 446 388 518]', 'unclear_single'],
          ['6', 'Acrorad_0712-1001-1-07-01034.jpg', '[571  65 631 128]', 'unclear_single'],
          ['7', 'Acrorad_0712-1001-1-07-01035.jpg', '[ 996  330 1125  448]', 'round_single'],
          ['8', 'Acrorad_0712-1001-1-07-01035.jpg', '[1169   12 1277  117]', 'round_single']
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

        self.assertEqual(count_defects.countDefects(defect_labels, 1035), expected_ouput)

    def test_dont_count_square(self):
        defect_labels = [
          ['', 'image', 'defect coordinates', 'class'],
          ['0', 'Acrorad_0712-1001-1-07-01028.jpg', '[ 970  741 1012  792]', 'square_single']
        ]

        self.assertEqual(count_defects.countDefects(defect_labels, 1028), [['Acrorad_0712-1001-1-07-01028.jpg', 0]])
    
    def test_next_image_name(self):
      test_image_name1 = 'Acrorad_0712-1001-1-07-00009.jpg'
      self.assertEqual(count_defects.next_image_name(test_image_name1), 'Acrorad_0712-1001-1-07-00010.jpg')

      test_image_name2 = 'Acrorad_0712-1001-1-07-00099.jpg'
      self.assertEqual(count_defects.next_image_name(test_image_name2), 'Acrorad_0712-1001-1-07-00100.jpg')

      test_image_name3 = 'Acrorad_0712-1001-1-07-00999.jpg'
      self.assertEqual(count_defects.next_image_name(test_image_name3), 'Acrorad_0712-1001-1-07-01000.jpg')

    def test_getDefectLabels(self):
      # test if getDefectLabels raises right exeption with wrong argument
      wrong_file_name = 'file.txt'
      with self.assertRaises(Exception) as context:
        count_defects.getDefectLabels(wrong_file_name)

        self.assertTrue('Name of the file needs to end with .csv!' in context.exception)

      wrong_file_name2 = 'file'
      with self.assertRaises(Exception) as context:
        count_defects.getDefectLabels(wrong_file_name2)

        self.assertTrue('Name of the file needs to end with .csv!' in context.exception)

    def test_saveCount(self):
      file_name = 'file'

if __name__ == '__main__':
    unittest.main()
