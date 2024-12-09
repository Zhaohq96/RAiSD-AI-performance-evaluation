#!/bin/bash

# The link to the datasets, the datasets csan be download from the link
show_help() {
    echo "Usage of run_RAiSD-AI.sh"
    echo -e "\nsh run_RAiSD-AI.sh input_folder_path architecture output_folder_path window_size region_length target_region epoch input_data_type group(FASTER-NN-G ONLY)"
    echo
    echo "The command will process the raw ms files, train the model and test with each RAiSD-AI tool. The trained model and testing results will be stored in output_folder_path/tool_name."
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
    echo "sh run_RAiSD-AI.sh Example_dataset/ SweepNet Example_result/ 128 100000 50000 10 1"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

# Parameter initiallization
input="$1"
epochs="$7"
RAiSD_AI_win="$4"
length="$5"
target="$6"
d_type="$8"
group="$9"

# Run SweepNet

if [ "$2" = "SweepNet" ]; then
	rm -r "$3""SweepNet/"
	if [ ! -d $3"SweepNet/" ]; then
		mkdir -p "$3""SweepNet/";
	fi
	
	./RAiSD-AI -n "SweepNet""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm
	./RAiSD-AI  -n "SweepNet""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f

	./RAiSD-AI -n "SweepNet""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm
	./RAiSD-AI  -n "SweepNet""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f

	./RAiSD-AI -n "SweepNet""${input%/}""Model" -I "RAiSD_Images.""SweepNet""${input%/}"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc SweepNet

	./RAiSD-AI -n "SweepNet""${input%/}"ModelTest -mdl RAiSD_Model."SweepNet""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."SweepNet""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".SweepNet""${input%/}"* "$3""SweepNet/"

# Run FAST-NN
elif [ "$2" = "FAST-NN" ]; then
	rm -r "$3""FAST-NN/"
	if [ ! -d $2"FAST-NN/" ]; then
		mkdir -p "$3""FAST-NN/";
	fi

	./RAiSD-AI -n "FAST-NN""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm -bin -typ $d_type
	./RAiSD-AI  -n "FAST-NN""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type

	./RAiSD-AI -n "FAST-NN""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm -bin -typ $d_type
	./RAiSD-AI  -n "FAST-NN""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type

	./RAiSD-AI -n "FAST-NN""${input%/}""Model" -I "RAiSD_Images.""FAST-NN""${input%/}"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FAST-NN

	./RAiSD-AI -n "FAST-NN""${input%/}"ModelTest -mdl RAiSD_Model."FAST-NN""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FAST-NN""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FAST-NN""${input%/}"* "$3""FAST-NN/"

# Run FASTER-NN
elif [ "$2" = "FASTER-NN" ]; then
	rm -r "$3""FASTER-NN/"
	if [ ! -d $2"FASTER-NN/" ]; then
		mkdir -p "$3""FASTER-NN/";
	fi

	./RAiSD-AI -n "FASTER-NN""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm -bin -typ $d_type
	./RAiSD-AI  -n "FASTER-NN""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type

	./RAiSD-AI -n "FASTER-NN""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm -bin -typ $d_type
	./RAiSD-AI  -n "FASTER-NN""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type

	./RAiSD-AI -n "FASTER-NN""${input%/}""Model" -I "RAiSD_Images.""FASTER-NN""${input%/}"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FASTER-NN

	./RAiSD-AI -n "FASTER-NN""${input%/}"ModelTest -mdl RAiSD_Model."FASTER-NN""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FASTER-NN""${input%/}"* "$3""FASTER-NN/"

# Run FASTER-NN-G
elif [ "$2" = "FASTER-NN-G" ]; then
	rm -r "$3""FASTER-NN-G""$group""/"
	if [ ! -d "$3""FASTER-NN-G""$group""/" ]; then
		mkdir -p "$3""FASTER-NN-G""$group""/";
	fi

	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm
	./RAiSD-AI  -n "FASTER-NN-G""$group""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f
#	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR2 -f
#	./RAiSD-AI  -n "FASTER-NN-G""$group""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR2 -f 

	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm
	./RAiSD-AI  -n "FASTER-NN-G""$group""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f
#	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE2 -f
#	./RAiSD-AI  -n "FASTER-NN-G""$group""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE2 -f

	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}""Model" -I "RAiSD_Images.""FASTER-NN-G""$group""${input%/}"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FASTER-NN-G -g $group 

	./RAiSD-AI -n "FASTER-NN-G""$group""${input%/}"ModelTest -mdl RAiSD_Model."FASTER-NN-G""$group""${input%/}""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN-G""$group""${input%/}"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FASTER-NN-G""$group""${input%/}"* "$3""FASTER-NN-G""$group""/"
fi
