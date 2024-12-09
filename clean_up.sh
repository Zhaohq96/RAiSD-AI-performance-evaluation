#!/bin/bash

# remove all environments
conda env remove --name diploSHIC
conda env remove --name SURFDAWave
conda env remove --name T-REx
conda env remove --name Net2
conda env remove --name raisd-ai

# remove the entire folder
cd ../..
rm -r RAiSD-AI2
