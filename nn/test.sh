#!/bin/bash
#SBATCH --job-name=test
#SBATCH -o result.txt
#SBATCH -p test
#SBATCH -c 4
#SBATCH -t 10:00
#SBATCH --mem-per-cpu=100

python autoenc.py
