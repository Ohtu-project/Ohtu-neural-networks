#!/bin/bash
#SBATCH --job-name=test
#SBATCH -o result.txt
#SBATCH -p gpu
#SBATCH -c 4
#SBATCH --Gres:gpu=1
#SBATCH --mem-per-cpu=100

python gpu_autoenc.py
