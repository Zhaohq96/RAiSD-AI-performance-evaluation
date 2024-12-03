#!/bin/bash

# The link to the datasets, the datasets csan be download from the link
show_help() {
    echo "This script is to reproduce the comarison results in RAiSD-AI paper."
    echo
    echo "Usage of run_all_tools.sh"
    echo
    echo -e "\nsh run_all_tools.sh input_folder_path output_folder_path"
    echo
    echo "The command will process the raw ms files, train the model and test with each tool. The trained model and testing results will be stored in output_folder_path/tool_name. A csv file that contains evaluation results of all tools will be in output_folder_path/ and named Collection.csv."
    echo
    echo -e "The input folder that contained raw ms files shoud be structured as:"
    echo -e "input_folder"
    echo -e "\ttrain"
    echo -e "\t--neutral.ms"
    echo -e "\t--selsweep.ms"
    echo -e "\ttest"
    echo -e "\t--neutral.ms"
    echo -e "\t--selsweep.ms"
    echo
    echo "NOTE: please add '/' at the end of each folder path."
    echo
    echo "Quick example:"
    echo "sh run_all_tools.sh Example_dataset/ Example_result/"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

# Default parameters for evaluation
diploSHIC_win=128 # window size of extracting snps from raw ms for diploSHIC
SURFDAWave_win=670 # window size of extracting snps from raw ms for SURFDAWave, note that SURFDAWave requires at least 670 snps
T_REx_win=128 # window size of extracting snps from raw ms for T-REx
RAiSD_AI_win=128 # window size of extracting snps from raw ms for RAiSD-AI tools
Net2_win=128 # window size of extracting snps from raw ms for Net2
num_sim_train=20 # number of simulations of each class of training sets, note that the training sets should be balanced
num_sim_test=20 # number of simulations of each class of testing sets, note that the testing sets should be balanced
epochs=10 # number of epochs for deep-learning-based methods including diploSHIC, Net2 and RAiSD-AI tools
length=100000 # length of genomic sequence
target=50000 # target of region that will be extracted from the genomic sequences
d_type=1 # data type for RAiSD-AI tools
group=8 # group size for FATER-NN-G



# Run diploSHIC
conda activate diploSHIC
sh run_diploSHIC.sh train $1train/neutral.ms $1train/selsweep.ms $2diploSHIC/ $diploSHIC_win $length $epochs
sh run_diploSHIC.sh test $1test/neutral.ms $1test/selsweep.ms $2diploSHIC/ $2diploSHIC/train/model/ $diploSHIC_win $length
conda deactivate

# Run SURFDAWave
conda activate SURFDAWave
sh run_SURFDAWave.sh train $1train/neutral.ms $1train/selsweep.ms $2SURFDAWave/ $SURFDAWave_win $length
sh run_SURFDAWave.sh test $1test/neutral.ms $1test/selsweep.ms $2SURFDAWave/ $2SURFDAWave/train/model/ $SURFDAWave_win $length
conda deactivate

# Run T-REx
conda activate T-REx
sh run_T-REx.sh $1train/neutral.ms $1train/selsweep.ms $1test/neutral.ms $1test/selsweep.ms $2T-REx/ $T_REx_win $length $num_sim_train $num_sim_test 
conda deactivate

# Run Net2
conda activate Net2
sh run_Net2.sh $1 $2Net2/ $Net2_win $length $target $epochs
conda deactivate


# Run RAiSD-AI tool
conda activate raisd-ai

# Run SweepNet tool

sh run_RAiSD-AI.sh $1 SweepNet $2 $RAiSD_AI_win $length $target $epochs $d_type $group

# Run FAST-NN

sh run_RAiSD-AI.sh $1 FAST-NN $2 $RAiSD_AI_win $length $target $epochs $d_type $group

# Run FASTER-NN

sh run_RAiSD-AI.sh $1 FASTER-NN $2 $RAiSD_AI_win $length $target $epochs $d_type $group

# Run FASTER-NN-G8

sh run_RAiSD-AI.sh $1 FASTER-NN-G $2 $RAiSD_AI_win $length $target $epochs $d_type $group

# Run FASTER-NN-G128

sh run_RAiSD-AI.sh $1 FASTER-NN-G $2 $RAiSD_AI_win $length $target $epochs $d_type 128

# Collect results
sh collect_result.sh "$2" "$2"
