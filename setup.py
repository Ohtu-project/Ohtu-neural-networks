
from setuptools import setup, find_packages

setup(name='Ohtu-neural-networks',
      version='0.1',
      description='Project for Helsinki Institute of Physics, CMS upgrade project.',
      url='https://github.com/Ohtu-project/Ohtu-neural-networks',
      author='Neural network-group',
      author_email='matti.leinonen@helsinki.fi',
      packages=find_packages(exclude=['tests'])
      )
