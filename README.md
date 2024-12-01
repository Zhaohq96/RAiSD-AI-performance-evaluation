# RAiSD-AI-Experiment
## About
This repository is to reproduce the comparison of RAiSD-AI against other selective sweep identification tools in the paper "". To facilitate the execution of the experiment, we made minor modifications to the code of these tools to enable customizable input and output paths. Specifically, we modified the code of diploS/HIC to make it as a binary classifier for distinguishing selective sweep from neutral region.

## Download and move to RAiSD-AI folder
To download the 

## To build virtual environment for each tool
As the tools require different versions of pacakges, we recommand to ultilize anaconda to build separate virtual environment for each tool. The installation of Anaconda can be found via https://www.anaconda.com/. After installation of Anaconda, you can use the following command to activate base environment.

``source path_to_anaconda3/bin/activate``

where _path_to_anaconda3_ is the path of Anaconda folder.
### Basic installation
To run the command for basic environment establishment for each tool:

```
sh install_environment.sh
```

### diploS/HIC
To activate diploS/HIC envorinment by:

```
conda activate diploSHIC
```

To install diploS/HIC by:


```
cd TOOLS/DIPLOSHIC/diploSHIC; python setup.py install; cd ../../..
```

To deactivate diploS/HIC envorinment by:

```
conda deactivate
```

### T-REx
To activate SURFDAWave envorinment by:

```
conda activate T-REx
```

To install required R packages of T-REx by:
1) To start the R programming environment

```
R
```

2) To install required pacakges in R:

```
install.packages(c("abind", "MASS", "glmnet","rTensor","ranger"))
```

```
install.packages("liquidSVM", repos="http://pnp.mathematik.uni-stuttgart.de/isa/steinwart/software/R")
```

3) 
To deactivate diploS/HIC envorinment by:

```
conda deactivate
```
