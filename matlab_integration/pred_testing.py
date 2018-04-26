#from matlab_integration import Predictions
import Predictions

import unittest
import mock
import shutil, tempfile
from os import path
import os.path
os.path.isfile = lambda path: path == '/path/to/file/resnet50_csv_50_13april2018_fixed.h5'
os.path.isfile = lambda path: path == '/home/matleino/Ohtu-neural-networks/matlab_integration/images/'

params = ['Predictions.py', '/path/to/file/resnet50_csv_50_13april2018_fixed.h5', '/home/matleino/Ohtu-neural-networks/matlab_integration/images/', 'results.csv']
Predictions.main(params)


"""
class TestCheckFile(unittest.TestCase):

    @mock.patch('app.os.listdir')
    def test_check_file_should_succeed(self, mock_listdir):
        mock_listdir.return_value = ['a.json', 'b.json', 'c.json', 'd.txt']
        files = check_files('.')
        self.assertEqual(3, len(files))

    @mock.patch('app.os.listdir')
    def test_check_file_should_fail(self, mock_listdir):
        mock_listdir.return_value = ['a.json', 'b.json', 'c.json', 'd.txt']
        files = check_files('.')
        self.assertNotEqual(2, len(files))

if __name__ == '__main__':
    unittest.main()
    """