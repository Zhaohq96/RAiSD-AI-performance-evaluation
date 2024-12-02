# RAiSD-AI-Experiment
## About
This repository is to reproduce the comparison of RAiSD-AI against other selective sweep identification tools in the paper "". To facilitate the execution of the experiment, we made minor modifications to the code of these tools to enable customizable input and output paths. Specifically, we modified the code of diploS/HIC to make it as a binary classifier for distinguishing selective sweep from neutral region.

## Setup
### RAiSD-AI download and compile
Firstly, to download and compile RAiSD-AI via https://github.com/alachins/raisd-ai.

### Toolchain download
To enter the RAiSD-AI folder

``cd path_to_RAiSD-AI``

To download and move the source files to the RAiSD-AI folder:

```
wget https://github.com/Zhaohq96/RAiSD-AI-Experiment/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-Experiment-main/; mv README.md README-RAiSD-AI-Experiment.md; mv * ../; cd ..; rm -r RAiSD-AI-Experiment-main/; rm master.zip; gcc convert.c -o convert -lm -g3; tar -xzvf Example_dataset.tar.gz; chmod +x ./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh;
```


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

To select the first cloud for downloading.

```
install.packages("liquidSVM", repos="http://pnp.mathematik.uni-stuttgart.de/isa/steinwart/software/R")
```

To quit R:
```
q()
```
To select 'y' to store the image.

3) To install pip packages:

```
pip3 install pandas numpy==1.24 scipy argparse seaborn
```

```
pip3 install -U scikit-image
```

4) 
To deactivate T-REx envorinment by:

```
conda deactivate
```

## Quick example
To evaluate all tools on a very small datasets:

```
sh run_all_tools.sh Example_dataset/ Example_result/
```

The output files related to each tool will be stored in the subfolder of Example_result/ named after them. The results will be collected in the file Example_result/Collection.csv

## Usage of each script
### run_all_tools.sh
```
This script is to reproduce the comarison results in RAiSD-AI paper.

Usage of run_all_tools.sh


sh run_all_tools.sh input_folder_path output_folder_path

The command will process the raw ms files, train the model and test with each tool. The trained model and testing results will be stored in output_folder_path/tool_name. A csv file that contains evaluation results of all tools will be in output_folder_path/ and named Collection.csv.

The input folder that contained raw ms files shoud be structured as:
input_folder
	train
	--neutral.ms
	--selsweep.ms
	test
	--neutral.ms
	--selsweep.ms

NOTE: please add '/' at the end of each folder path.

Quick example:
sh run_all_tools.sh Example_dataset/ Example_result/
```

### run_diploSHIC.sh
```
Usage of run_diploSHIC.sh

There are two modes:

Train mode: 
sh run_diploSHIC.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The diploSHIC training model and training results will be stored in output_folder_path/train/model. The training summary statistics files will be stored in output_folder_path/train/model/training (training set) and output_folder_path/train/model/testing (validation set).

Test mode: 
sh run_diploSHIC.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path hdf5_model_folder_path window_size

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'hdf5_model_folder_path' should point to the folder that contains the hdf5 training model of diploSHIC. The testing results will be stored in output_folder_path/test/result.

NOTE: please add '/' at the end of each folder path.

Quick example:
conda activate diploSHIC
sh run_diploSHIC.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 128
sh run_diploSHIC.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 128
```

### run_SURFDAWave.sh
```
Usage of run_SURFDAWave.sh

There are two modes:

Train mode: 
sh run_SURFDAWave.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The file of training summary statistics, SURFDAWave training model and training results will be stored in output_folder_path/train/model.

Test mode: 
sh run_SURFDAWave.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path rds_model_folder_path window_size

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'rds_model_folder_path' should point to the folder that contains the hdf5 training model of SURFDAWave. The testing results will be stored in output_folder_path/test/result.

NOTE: please add '/' at the end of each folder path.

Quick example:
conda activate SURFDAWave
sh run_SURFDAWave.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 670
sh run_SURFDAWave.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 670
```

### run_T-REx.sh
```
Usage of run_T-REx.sh

sh run_T-REx.sh training_neutral_ms_file_path training_selective_sweep_ms_file_path testing_neutral_ms_file_path testing_selective_sweep_ms_file_path outout_folder_path window_size number_of_training simulations number_of_testing_simulations

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/extracted_data. The processed ms files of training and testing sets will be stored in output_folder_path/MS_files_train and output_folder_path/MS_files_test, respectively. The folder of output_folder_path/CVF_files contains the cvf files converted from the processed ms files. The testing results will be stored in output_folder_path/Results

NOTE: please add '/' at the end of each folder path and the training sets and testing sets should be balanced sets (same number of simulations for each class).

Quick example:
conda activate T-REx
sh run_T-REx.sh Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ 128 20 20
```
