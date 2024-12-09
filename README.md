# RAiSD-AI-performance-evaluation
## About
This repository is to reproduce the comparison of RAiSD-AI against other selective sweep identification tools in the paper "". 

## Declaration
For standardizing experimental setups and replicating the comparison results, we modified the source codes of the following tools and provide the modified tools in the repository.
### diploS/HIC
Citation: _Kern, A. D., & Schrider, D. R. (2018). diploS/HIC: an updated approach to classifying selective sweeps. G3: Genes, Genomes, Genetics, 8(6), 1959-1970._

Tool download link: https://github.com/kr-colab/diploSHIC

Date of obtaining the tool: Oct, 2021

Modification:
1) modified the source code to make diploS/HIC as a binary classifier.
2) used a C program to extract the same region that RAiSD-AI tools analyze from the raw ms file for aligning the comparison.

### SURFDAWave
Citation: _Mughal, M. R., Koch, H., Huang, J., Chiaromonte, F., & DeGiorgio, M. (2020). Learning the properties of adaptive regions with functional data analysis. PLoS genetics, 16(8), e1008896._

Tool download link: https://degiorgiogroup.fau.edu/surfdawave.html

Date of obtaining the tool: Oct, 2021

Modification:
1) used a C program to extract the same region that RAiSD-AI tools analyze from the raw ms file for aligning the comparison.

### T-REx
Citation: _Amin, M. R., Hasan, M., Arnab, S. P., & DeGiorgio, M. (2023). Tensor Decomposition-based Feature Extraction and Classification to Detect Natural Selection from Genomic Data. Molecular Biology and Evolution, 40(10), msad216._

Tool download link: https://github.com/RuhAm/T-REx

Date of obtaining the tool: Nov, 2024

Modification:
1) modified the source code to enable customizable input parameters.
2) used a C program to extract the same region that RAiSD-AI tools analyze from the raw ms file for aligning the comparison.

### Net2
Citation: _Nguembang Fadja, A., Riguzzi, F., Bertorelle, G., & Trucchi, E. (2021). Identification of natural selection in genomic data with deep convolutional neural network. BioData Mining, 14, 1-18._

Tool download link: https://bitbucket.org/ArnaudFadja/genetic_data_experiments/src/master/

Date of obtaining the tool: Oct, 2021

Modification:
1) modified the source code to enable customizable input parameters.
2) used RAiSD-AI to provide input for aligning the comparison.

## Setup
### RAiSD-AI download and compile
Firstly, to download and compile RAiSD-AI via https://github.com/alachins/raisd-ai. Using quick command:

```
 mkdir RAiSD-AI; cd RAiSD-AI; wget https://github.com/alachins/RAiSD-AI/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-master; ./compile-RAiSD-AI.sh
```

### Toolchain download
To enter the RAiSD-AI folder, if you followed the last command to download and compile RAiSD-AI, you would already be in the RAiSD-AI folder.

To download and move the source files to the RAiSD-AI folder:

```
wget https://github.com/Zhaohq96/RAiSD-AI-performance-evaluation/archive/refs/heads/master.zip; unzip master.zip; cd RAiSD-AI-performance-evaluation-main/; mv README.md README-RAiSD-AI-performance-evaluation.md; mv * ../; cd ..; rm -r RAiSD-AI-performance-evaluation-main/; rm master.zip; gcc convert.c -o convert -lm; tar -xzvf Example_dataset.tar.gz; chmod +x ./SCRIPTS/diploSHIC_scripts/diploSHIC_spliting.sh;
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
To activate T-REx envorinment by:

```
conda activate T-REx
```

To install required R packages of T-REx by:
1) To start the R programming environment

```
R
```

2) To install required pacakges in R and select a mirror for downloading:

```
install.packages(c("abind", "MASS", "glmnet","rTensor","ranger"))
```


```
install.packages("liquidSVM", repos="http://pnp.mathematik.uni-stuttgart.de/isa/steinwart/software/R")
```

To quit R and select 'y' to save the image:
```
q()
```


3) To install pip packages:

```
pip3 install pandas numpy==1.24 scipy==1.10 argparse seaborn
```

```
pip3 install -U scikit-image
```

4) To deactivate T-REx envorinment by:

```
conda deactivate
```

## Quick example
To evaluate all tools on a very small datasets:

```
bash run_all_tools.sh Example_dataset/ Example_result/
```

The output files related to each tool will be stored in the subfolder of Example_result/ named after them. The results will be collected in the file Example_result/Collection.csv

## Remove all environment and the entire folder
To Remove all environment and the entire folder by the command:

```
sh clean_up.sh
```

## Usage of each script
### run_all_tools.sh
```
This script is to reproduce the comarison results in RAiSD-AI paper.

Usage of run_all_tools.sh


bash run_all_tools.sh input_folder_path output_folder_path

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
sh run_diploSHIC.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size length epoch

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The diploSHIC training model and training results will be stored in output_folder_path/train/model. The training summary statistics files will be stored in output_folder_path/train/model/training (training set) and output_folder_path/train/model/testing (validation set).

Test mode: 
sh run_diploSHIC.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path hdf5_model_folder_path window_size length

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'hdf5_model_folder_path' should point to the folder that contains the hdf5 training model of diploSHIC. The testing results will be stored in output_folder_path/test/result.

NOTE: please add '/' at the end of each folder path.

Quick example:
conda activate diploSHIC
sh run_diploSHIC.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 128 100000 100
sh run_diploSHIC.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 128 100000
```

### run_SURFDAWave.sh
```
Usage of run_SURFDAWave.sh

There are two modes:

Train mode: 
sh run_SURFDAWave.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size length

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The file of training summary statistics, SURFDAWave training model and training results will be stored in output_folder_path/train/model.

Test mode: 
sh run_SURFDAWave.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path rds_model_folder_path window_size length

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'rds_model_folder_path' should point to the folder that contains the hdf5 training model of SURFDAWave. The testing results will be stored in output_folder_path/test/result.

NOTE: please add '/' at the end of each folder path.

Quick example:
conda activate SURFDAWave
sh run_SURFDAWave.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 670 100000
sh run_SURFDAWave.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 670 100000
```

### run_T-REx.sh
```
Usage of run_T-REx.sh

sh run_T-REx.sh training_neutral_ms_file_path training_selective_sweep_ms_file_path testing_neutral_ms_file_path testing_selective_sweep_ms_file_path outout_folder_path window_size length number_of_training_simulations number_of_testing_simulations

The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/extracted_data. The processed ms files of training and testing sets will be stored in output_folder_path/MS_files_train and output_folder_path/MS_files_test, respectively. The folder of output_folder_path/CVF_files contains the cvf files converted from the processed ms files. The testing results will be stored in output_folder_path/Results

NOTE: please add '/' at the end of each folder path and the training sets and testing sets should be balanced sets (same number of simulations for each class).

Quick example:
conda activate T-REx
sh run_T-REx.sh Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ 128 100000 20 20
```

### run_Net2.sh
```
Usage of run_Net2.sh

sh run_Net2.sh input_folder_path output_folder_path window_size length target epoch

The command will extract the given size of window (number of snps) from the center of the raw ms files, convert the extracted matrices into images and store them in output_folder_path/results. The training model will be stored in output_folder_path/results/model. The training results and testing results will be stored in output_folder_path/results/log.

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
conda activate Net2
sh run_Net2.sh Example_dataset/ Example_result/ 128 100000 50000 10
```

### run_RAiSD-AI.sh
```
Usage of run_RAiSD-AI.sh

sh run_RAiSD-AI.sh input_folder_path architecture output_folder_path window_size region_length target_region epoch input_data_type group(FASTER-NN-G ONLY)

The command will process the raw ms files, train the model and test with each RAiSD-AI tool. The trained model and testing results will be stored in output_folder_path/tool_name.

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
sh run_RAiSD-AI.sh Example_dataset/ SweepNet Example_result/ 128 100000 50000 10 1
```
