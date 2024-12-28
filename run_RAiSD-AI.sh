#!/bin/bash

# The link to the datasets, the datasets csan be download from the link
show_help() {
    echo "Usage of run_RAiSD-AI.sh"
    echo -e "\nsh run_RAiSD-AI.sh -i input_folder_path -a architecture -n run_ID -o output_folder_path -w window_size -l region_length -t target_region -e epoch -d input_data_type -g group(FASTER-NN-G ONLY) -b if_selsweep_file_is_mbs_or_not(0: non-mbs, 1: mbs)"
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
    echo "conda activate raisd-ai"
    echo "sh run_RAiSD-AI.sh -i Example_dataset/ -a SweepNet -n Example -o Example_result/ -w 128 -l 100000 -t 50000 -e 10 -d 1 -b 0"
}

# Parameter initiallization

epochs=10
RAiSD_AI_win=128
length=100000
target=50000
d_type=1
group=8
mbs=0

while getopts "hi:a:n:o:w:l:t:e:d:g:b:" opt
do
	case "${opt}" in
		h) show_help; exit 0;;
		i) input=${OPTARG};;
		a) arch=${OPTARG};;
		n) ID=${OPTARG};;
		o) output=${OPTARG};;
		w) RAiSD_AI_win=${OPTARG};;
		l) length=${OPTARG};;
		t) target=${OPTARG};;
		e) epochs=${OPTARG};;
		d) d_type=${OPTARG};;
		g) group=${OPTARG};;
		b) mbs=${OPTARG};;
	esac
done


# Run SweepNet

if [ "$arch" = "SweepNet" ]; then
	rm -r "$output""SweepNet/"
	if [ ! -d $output"SweepNet/" ]; then
		mkdir -p "$output""SweepNet/";
	fi
	
	./RAiSD-AI -n "SweepNet""$ID"TrainingData2DSNP -I "$input"train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm
	./RAiSD-AI -n "SweepNet""$ID"TestingData2DSNP -I "$input"test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm
	
	if [ "$mbs" = "1" ]; then
		./RAiSD-AI  -n "SweepNet""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -b
		./RAiSD-AI  -n "SweepNet""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -b
	elif [ "$mbs" = "0" ]; then
		./RAiSD-AI  -n "SweepNet""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f
		./RAiSD-AI  -n "SweepNet""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f
	fi

	./RAiSD-AI -n "SweepNet""$ID""Model" -I "RAiSD_Images.""SweepNet""$ID"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc SweepNet

	./RAiSD-AI -n "SweepNet""$ID"ModelTest -mdl RAiSD_Model."SweepNet""$ID""Model" -f -op MDL-TST -I RAiSD_Images."SweepNet""$ID"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".SweepNet""$ID"* "$output""SweepNet/"

# Run FAST-NN
elif [ "$arch" = "FAST-NN" ]; then
	rm -r "$output""FAST-NN/"
	if [ ! -d $arch"FAST-NN/" ]; then
		mkdir -p "$output""FAST-NN/";
	fi

	./RAiSD-AI -n "FAST-NN""$ID"TrainingData2DSNP -I "$input"train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm -bin -typ $d_type
	./RAiSD-AI -n "FAST-NN""$ID"TestingData2DSNP -I "$input"test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm -bin -typ $d_type
	
	
	if [ "$mbs" = "1" ]; then
		./RAiSD-AI  -n "FAST-NN""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type -b
		./RAiSD-AI  -n "FAST-NN""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type -b
	elif [ "$mbs" = "0" ]; then
		./RAiSD-AI  -n "FAST-NN""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type
		./RAiSD-AI  -n "FAST-NN""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type
	fi
	
	./RAiSD-AI -n "FAST-NN""$ID""Model" -I "RAiSD_Images.""FAST-NN""$ID"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FAST-NN

	./RAiSD-AI -n "FAST-NN""$ID"ModelTest -mdl RAiSD_Model."FAST-NN""$ID""Model" -f -op MDL-TST -I RAiSD_Images."FAST-NN""$ID"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FAST-NN""$ID"* "$output""FAST-NN/"

# Run FASTER-NN
elif [ "$arch" = "FASTER-NN" ]; then
	rm -r "$output""FASTER-NN/"
	if [ ! -d $arch"FASTER-NN/" ]; then
		mkdir -p "$output""FASTER-NN/";
	fi

	./RAiSD-AI -n "FASTER-NN""$ID"TrainingData2DSNP -I "$input"train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm -bin -typ $d_type
	./RAiSD-AI -n "FASTER-NN""$ID"TestingData2DSNP -I "$input"test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm -bin -typ $d_type
	
	
	if [ "$mbs" = "1" ]; then
		./RAiSD-AI  -n "FASTER-NN""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type -b
		./RAiSD-AI  -n "FASTER-NN""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type -b
	elif [ "$mbs" = "0" ]; then
		./RAiSD-AI  -n "FASTER-NN""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -typ $d_type
		./RAiSD-AI  -n "FASTER-NN""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -typ $d_type
	fi

	./RAiSD-AI -n "FASTER-NN""$ID""Model" -I "RAiSD_Images.""FASTER-NN""$ID"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FASTER-NN

	./RAiSD-AI -n "FASTER-NN""$ID"ModelTest -mdl RAiSD_Model."FASTER-NN""$ID""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN""$ID"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FASTER-NN""$ID"* "$output""FASTER-NN/"

# Run FASTER-NN-G
elif [ "$arch" = "FASTER-NN-G" ]; then
	rm -r "$output""FASTER-NN-G""$group""/"
	if [ ! -d "$output""FASTER-NN-G""$group""/" ]; then
		mkdir -p "$output""FASTER-NN-G""$group""/";
	fi

	./RAiSD-AI -n "FASTER-NN-G""$group""$ID"TrainingData2DSNP -I "$input"train/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTR -f -frm -bin
	./RAiSD-AI -n "FASTER-NN-G""$group""$ID"TestingData2DSNP -I "$input"test/neutral.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl neutralTE -f -frm -bin
	
	if [ "$mbs" = "1" ]; then
		./RAiSD-AI  -n "FASTER-NN-G""$group""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin -b
		./RAiSD-AI  -n "FASTER-NN-G""$group""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin -b
	elif [ "$mbs" = "0" ]; then
		./RAiSD-AI  -n "FASTER-NN-G""$group""$ID"TrainingData2DSNP -I "$input"train/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTR -f -bin
		./RAiSD-AI  -n "FASTER-NN-G""$group""$ID"TestingData2DSNP -I "$input"test/selsweep.ms -w $RAiSD_AI_win -L $length -its $target -op IMG-GEN -icl sweepTE -f -bin
	fi


	./RAiSD-AI -n "FASTER-NN-G""$group""$ID""Model" -I "RAiSD_Images.""FASTER-NN-G""$group""$ID"TrainingData2DSNP -f -op MDL-GEN -frm -e $epochs -arc FASTER-NN-G -g $group 

	./RAiSD-AI -n "FASTER-NN-G""$group""$ID"ModelTest -mdl RAiSD_Model."FASTER-NN-G""$group""$ID""Model" -f -op MDL-TST -I RAiSD_Images."FASTER-NN-G""$group""$ID"TestingData2DSNP -clp 2 sweepTR=sweepTE neutralTR=neutralTE

	mv "RAiSD_"*".FASTER-NN-G""$group""$ID"* "$output""FASTER-NN-G""$group""/"
fi
