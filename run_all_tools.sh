#!/bin/bash


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

# Run diploSHIC
conda activate diploSHIC
sh run_diploSHIC.sh train $1train/neutral.ms $1train/selsweep.ms $2diploSHIC/ $diploSHIC_win
sh run_diploSHIC.sh test $1test/neutral.ms $1test/selsweep.ms $2diploSHIC/ $2diploSHIC/train/model/ $diploSHIC_win
conda deactivate

# Run SURFDAWave
conda activate SURFDAWave
sh run_SURFDAWave.sh train $1train/neutral.ms $1train/selsweep.ms $2SURFDAWave/ $SURFDAWave_win
sh run_SURFDAWave.sh test $1test/neutral.ms $1test/selsweep.ms $2SURFDAWave/ $2SURFDAWave/train/model/ $SURFDAWave_win
conda deactivate

# Run T-REx
conda activate T-REx
sh run_T-REx.sh $1train/neutral.ms $1train/selsweep.ms $1test/neutral.ms $1test/selsweep.ms $2T-REx/ $T_REx_win $num_sim_train $num_sim_test
conda deactivate

# Run Net2
conda activate Net2
sh run_Net2.sh $1 $2Net2/ $Net2_win
conda deactivate

# Run RAiSD-AI tools
input="$1"
epochs=10
TRAINING_NEUTRAL=$1train/neutral.ms
TRAINING_SWEEP=$1train/selsweep.ms
TEST_NEUTRAL=$1test/neutral.ms
TEST_SWEEP=$1test/selsweep.ms
# Run SweepNet
conda activate raisd-ai
rm -r "$2""SweepNet/"
if [ ! -d $2"SweepNet/" ]; then
	mkdir -p "$2""SweepNet/";
fi

./RAiSD-AI -n "SweepNet""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR -f -frm -O
./RAiSD-AI  -n "SweepNet""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR -f -O

./RAiSD-AI -n "SweepNet""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE -f -frm -O
./RAiSD-AI  -n "SweepNet""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE -f -O

./RAiSD-AI -n "SweepNet""${input%/}""Model" -I "RAiSD_Images.""SweepNet""${input%/}"TrainingData2DSNP -f -op MDL-GEN -O -frm -e $epochs -arc SweepNet

./RAiSD-AI -n "SweepNet""${input%/}"ModelTest -mdl RAiSD_Model."SweepNet""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."SweepNet""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

mv "RAiSD_"*".SweepNet""${input%/}"* "$2""SweepNet/"

# Run FAST-NN
rm -r "$2""FAST-NN/"
if [ ! -d $2"FAST-NN/" ]; then
	mkdir -p "$2""FAST-NN/";
fi

./RAiSD-AI -n "FAST-NN""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR -f -frm -bin -typ 1 -O
./RAiSD-AI  -n "FAST-NN""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR -f -bin -typ 1 -O 

./RAiSD-AI -n "FAST-NN""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE -f -frm -bin -typ 1 -O
./RAiSD-AI  -n "FAST-NN""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE -f -bin -typ 1 -O

./RAiSD-AI -n "FAST-NN""${input%/}""Model" -I "RAiSD_Images.""FAST-NN""${input%/}"TrainingData2DSNP -f -op MDL-GEN -O -frm -e $epochs -arc FAST-NN

./RAiSD-AI -n "FAST-NN""${input%/}"ModelTest -mdl RAiSD_Model."FAST-NN""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FAST-NN""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

mv "RAiSD_"*".FAST-NN""${input%/}"* "$2""FAST-NN/"

# Run FASTER-NN
rm -r "$2""FASTER-NN/"
if [ ! -d $2"FASTER-NN/" ]; then
	mkdir -p "$2""FASTER-NN/";
fi

./RAiSD-AI -n "FASTER-NN""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR -f -frm -bin -typ 1 -O
./RAiSD-AI  -n "FASTER-NN""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR -f -bin -typ 1 -O 

./RAiSD-AI -n "FASTER-NN""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE -f -frm -bin -typ 1 -O
./RAiSD-AI  -n "FASTER-NN""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE -f -bin -typ 1 -O

./RAiSD-AI -n "FASTER-NN""${input%/}""Model" -I "RAiSD_Images.""FASTER-NN""${input%/}"TrainingData2DSNP -f -op MDL-GEN -O -frm -e $epochs -arc FASTER-NN

./RAiSD-AI -n "FASTER-NN""${input%/}"ModelTest -mdl RAiSD_Model."FASTER-NN""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

mv "RAiSD_"*".FASTER-NN""${input%/}"* "$2""FASTER-NN/"

# Run FASTER-NN-G8
rm -r "$2""FASTER-NN-G8/"
if [ ! -d $2"FASTER-NN-G8/" ]; then
	mkdir -p "$2""FASTER-NN-G8/";
fi

./RAiSD-AI -n "FASTER-NN-G8""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR1 -f -frm -O
./RAiSD-AI  -n "FASTER-NN-G8""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR1 -f -O 
./RAiSD-AI -n "FASTER-NN-G8""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR2 -f -O
./RAiSD-AI  -n "FASTER-NN-G8""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR2 -f -O 

./RAiSD-AI -n "FASTER-NN-G8""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE1 -f -frm -O
./RAiSD-AI  -n "FASTER-NN-G8""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE1 -f -O
./RAiSD-AI -n "FASTER-NN-G8""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE2 -f -O
./RAiSD-AI  -n "FASTER-NN-G8""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE2 -f -O

./RAiSD-AI -n "FASTER-NN-G8""${input%/}""Model" -I "RAiSD_Images.""FASTER-NN-G8""${input%/}"TrainingData2DSNP -f -op MDL-GEN -O -frm -e $epochs -arc FASTER-NN-G -g 8 -cl4 label00=neutralTR1 label01=sweepTR1 label10=neutralTR2 label11=sweepTR2

./RAiSD-AI -n "FASTER-NN-G8""${input%/}"ModelTest -mdl RAiSD_Model."FASTER-NN-G8""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN-G8""${input%/}"TestingData2DSNP -clp 4 sweepTR1=sweepTE1 neutralTR1=neutralTE1 sweepTR2=sweepTE2 neutralTR2=neutralTE2

mv "RAiSD_"*".FASTER-NN-G8""${input%/}"* "$2""FASTER-NN-G8/"

# Run FASTER-NN-G128
rm -r "$2""FASTER-NN-G128/"
if [ ! -d $2"FASTER-NN-G128/" ]; then
	mkdir -p "$2""FASTER-NN-G128/";
fi

./RAiSD-AI -n "FASTER-NN-G128""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR1 -f -frm -O
./RAiSD-AI  -n "FASTER-NN-G128""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR1 -f -O 
./RAiSD-AI -n "FASTER-NN-G128""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTR2 -f -O
./RAiSD-AI  -n "FASTER-NN-G128""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTR2 -f -O 

./RAiSD-AI -n "FASTER-NN-G128""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE1 -f -frm -O
./RAiSD-AI  -n "FASTER-NN-G128""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE1 -f -O
./RAiSD-AI -n "FASTER-NN-G128""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl neutralTE2 -f -O
./RAiSD-AI  -n "FASTER-NN-G128""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L 100000 -its 50000 -op IMG-GEN -icl sweepTE2 -f -O

./RAiSD-AI -n "FASTER-NN-G128""${input%/}""Model" -I "RAiSD_Images.""FASTER-NN-G128""${input%/}"TrainingData2DSNP -f -op MDL-GEN -O -frm -e $epochs -arc FASTER-NN-G -g 8 -cl4 label00=neutralTR1 label01=sweepTR1 label10=neutralTR2 label11=sweepTR2

./RAiSD-AI -n "FASTER-NN-G128""${input%/}"ModelTest -mdl RAiSD_Model."FASTER-NN-G128""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN-G128""${input%/}"TestingData2DSNP -clp 4 sweepTR1=sweepTE1 neutralTR1=neutralTE1 sweepTR2=sweepTE2 neutralTR2=neutralTE2

mv "RAiSD_"*".FASTER-NN-G128""${input%/}"* "$2""FASTER-NN-G128/"

# Collect results
sh collect_result.sh "$2" "$2"
