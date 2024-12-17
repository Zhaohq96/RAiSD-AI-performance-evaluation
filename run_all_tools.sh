#!/bin/bash

# Datasets download links
# Mild bottleneck: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_mild_bottleneck/27908139?file=50811243
# Severe bottleneck: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_severe_bottleneck/27909696?file=50817474
# Recent migration: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_rececnt_migration/27909744?file=50817546
# Old migration: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_old_migration/27909774?file=50817612
# Low intensity recombination hotspot: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_low_intensity_recombination_hotspot/27936102?file=50901324
# High intensity recombination hotspot: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_high_intensity_recombination_hotspot/27936099?file=50901303


show_help() {
    echo "This script is to reproduce the comarison results in RAiSD-AI paper. For customized input, please change the parameters in this script to align to the setup."
    echo
    echo "Usage of run_all_tools.sh"
    echo
    echo -e "\nsh run_all_tools.sh input_folder_path output_folder_path RAiSD_AI_run_ID"
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
    echo "sh run_all_tools.sh Example_dataset/ Example_result/ Example"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

eval "$(conda shell.bash hook)"

# Default parameters for evaluation, can be modified if needed
diploSHIC_win=128 # window size of extracting snps from raw ms for diploSHIC
SURFDAWave_win=670 # window size of extracting snps from raw ms for SURFDAWave, note that SURFDAWave requires at least 670 snps
T_REx_win=128 # window size of extracting snps from raw ms for T-REx
RAiSD_AI_win=128 # window size of extracting snps from raw ms for RAiSD-AI tools
CNN_Nguembang_Fadja_win=128 # window size of extracting snps from raw ms for CNN_Nguembang_Fadja
num_sim_train=20 # number of simulations of each class of training sets, note that the training sets should be balanced
num_sim_test=20 # number of simulations of each class of testing sets, note that the testing sets should be balanced
epochs=10 # number of epochs for deep-learning-based methods including diploSHIC, CNN_Nguembang_Fadja and RAiSD-AI tools
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

# Run CNN_Nguembang_Fadja
conda activate CNN-Nguembang-Fadja
sh run_CNN_Nguembang_Fadja.sh $1 $2CNN_Nguembang_Fadja/ $CNN_Nguembang_Fadja_win $length $target $epochs $3
conda deactivate

# Run RAiSD-AI tool
conda activate raisd-ai

# Run SweepNet tool

sh run_RAiSD-AI.sh -i $1 -a SweepNet -o $2 -w $RAiSD_AI_win -l $length -t $target -e $epochs -d $d_type -g $group -n $3

# Run FAST-NN

sh run_RAiSD-AI.sh -i $1 -a FAST-NN -o $2 -w $RAiSD_AI_win -l $length -t $target -e $epochs -d $d_type -g $group -n $3

# Run FASTER-NN

sh run_RAiSD-AI.sh -i $1 -a FASTER-NN -o $2 -w $RAiSD_AI_win -l $length -t $target -e $epochs -d $d_type -g $group -n $3

# Run FASTER-NN-G8

sh run_RAiSD-AI.sh -i $1 -a FASTER-NN-G -o $2 -w $RAiSD_AI_win -l $length -t $target -e $epochs -d $d_type -g $group -n $3

# Run FASTER-NN-G128

sh run_RAiSD-AI.sh -i $1 -a FASTER-NN-G -o $2 -w $RAiSD_AI_win -l $length -t $target -e $epochs -d $d_type -g 128 -n $3

# Collect results
bash collect_result.sh "$2" "$2"
