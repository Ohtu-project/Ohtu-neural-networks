import unittest
 
class TestBasicFunction(unittest.TestCase):
    def test(self):
        self.assertTrue(True)

    def number_test(self):
        self.assertEqual(17, 5 + 5)
 
if __name__ == '__main__':
    unittest.main()
