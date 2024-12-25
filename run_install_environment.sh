#!/bin/bash

eval "$(conda shell.bash hook)"

# Create the virtual environment of RAiSD-AI via .yml file
conda env create -f ENVIRONMENT/environment-raisd-ai.yml

# Create the virtual environment of diploSHIC via .yml file
conda env create -f ENVIRONMENT/environment-diploSHIC.yml
conda activate diploSHIC
cd TOOLS/DIPLOSHIC/diploSHIC; python setup.py install; cd ../../..
conda deactivate


# Create the virtual environment of SURFDAWave via .yml file
conda env create -f ENVIRONMENT/environment-SURFDAWave.yml
conda activate SURFDAWave
Rscript ENVIRONMENT/environment-SURFDAWave.R
conda deactivate

# Create the virtual environment of T-REx via .yml file
conda env create -f ENVIRONMENT/environment-T-REx.yml
conda activate T-REx
Rscript ENVIRONMENT/environment-T-REx.R
pip3 install pandas numpy==1.24 scipy==1.10 argparse seaborn
pip3 install -U scikit-image
conda deactivate

# Create the virtual environment of CNN-Nguembang-Fadja via .yml file
conda env create -f ENVIRONMENT/environment-CNN-Nguembang-Fadja.yml
