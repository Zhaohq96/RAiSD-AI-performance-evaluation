#!/bin/bash

show_help() {
    echo "Usage of run_SURFDAWave.sh"
    echo
    echo "There are two modes:"
    echo
    echo -e "Train mode: \nsh run_SURFDAWave.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size length recombination_dataset_or_not(0: non-recombination, 1: recombination)"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The file of training summary statistics, SURFDAWave training model and training results will be stored in output_folder_path/train/model."
    echo
    echo -e "Test mode: \nsh run_SURFDAWave.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path rds_model_folder_path window_size length recombination_dataset_or_not(0: non-recombination, 1: recombination)"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'rds_model_folder_path' should point to the folder that contains the hdf5 training model of SURFDAWave. The testing results will be stored in output_folder_path/test/result."
    echo
    echo "NOTE: please add '/' at the end of each folder path."
    echo
    echo "Quick example:"
    echo "conda activate SURFDAWave"
    echo "sh run_SURFDAWave.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 670 100000 0"
    echo "sh run_SURFDAWave.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 670 100000 0"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi


if [ ! -d $4 ]; then
	rm -r "$4""$1"/;
	mkdir -p "$4""$1"/;
fi

# Train
if [ "$1" = "train" ]; then
	mkdir -p "$4""$1"/model;
	if [ "$7" = "0" ]; then
		sh ./SCRIPTS/SURFDAWave_scripts/SURFDAWave_training.sh "$2" "$3" "$4""$1"/model;
	elif [ "$7" = "1" ]; then
		./ProcessSURFDAWave -i $2 -l $6 -o "$2"sur;
		./ProcessSURFDAWave -i $3 -l $6 -o "$3"sur;
		sh ./SCRIPTS/SURFDAWave_scripts/SURFDAWave_training.sh "$2"sur "$3"sur "$4""$1"/model;
	else
		echo "Wrong input data format"
		exit 0
	fi
	echo 'training finish';
	rm "$2"sur;
	rm "$3"sur;

# Test
elif [ "$1" = "test" ]; then
	mkdir -p "$4""$1"/result;
	if [ "$8" = "0" ]; then
		sh ./SCRIPTS/SURFDAWave_scripts/SURFDAWave_testing.sh "$2" "$3" $5 "$4""$1"/result;
	elif [ "$8" = "1" ]; then
		./ProcessSURFDAWave -i $2 -l $6 -o "$2"sur;
		./ProcessSURFDAWave -i $3 -l $6 -o "$3"sur;
		sh ./SCRIPTS/SURFDAWave_scripts/SURFDAWave_testing.sh "$2"sur "$3"sur $5 "$4""$1"/result;
	else
		echo "Wrong input data format"
		exit 0
	fi
	rm "$2"sur;
	rm "$3"sur;
	echo 'done';
else
	echo 'Unknown mode';
fi
