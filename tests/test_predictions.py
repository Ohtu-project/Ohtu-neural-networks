from __future__ import absolute_import

import unittest
import os, sys
from unittest import mock

sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))

from matlab_integration import Predictions_mat

class TestBasicFunction(unittest.TestCase):

    @mock.patch('os.path.isfile')
    def test_needs_to_be_h5_file(self, mock_isfile):
        mock_isfile.return_value = True
        params = ['Predictions.py', '/path/to/file/resnet50.txt', '/path/to/dir/images/', 'results.csv']
        self.assertTrue('File should be a .h5 file!' in Predictions_mat.get_errors(params))

    @mock.patch('os.path.isfile')
    def test_path_to_trained_model_needs_to_be_correct(self, mock_isfile):
        mock_isfile.return_value = False
        params = ['Predictions.py', '/wrong/path/to/resnet50.h5', '/path/to/dir/images/', 'results.csv']
        self.assertTrue(params[1] + ' not a correct path!' in Predictions_mat.get_errors(params))

    @mock.patch('os.path.isdir')
    def test_path_to_image_directory_needs_to_be_correct(self, mock_isdir):
        mock_isdir.return_value = False
        params = ['Predictions.py', '/path/to/resnet50.h5', '/path/to/wrong/dir/images/', 'results.csv']
        self.assertTrue(params[2] + ' not a correct directory!' in Predictions_mat.get_errors(params))

    @mock.patch('os.path.isfile')
    def test_results_file_needs_to_be_a_csv_file(self, mock_isfile):
        mock_isfile.return_value = True
        params = ['Predictions.py', '/path/to/resnet50.h5', '/path/to/dir/images/', 'results.txt']
        self.assertTrue('Name of the file needs to end with .csv!' in Predictions_mat.get_errors(params))

    @mock.patch('os.path.isfile')
    def test_result_file_cant_exists_before_running_predictions(self, mock_isfile):
        mock_isfile.return_value = True
        params = ['Predictions.py', '/path/to/resnet50.h5', '/path/to/dir/images/', 'results.csv']
        self.assertTrue(params[3] + " file of this name already exists!" in Predictions_mat.get_errors(params))


if __name__ == '__main__':
    unittest.main()