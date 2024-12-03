#!/bin/bash

show_help() {
    echo "Usage of run_diploSHIC.sh"
    echo
    echo "There are two modes:"
    echo
    echo -e "Train mode: \nsh run_diploSHIC.sh train neutral_ms_file_path selective_sweep_ms_file_path outout_folder_path window_size"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/train/extracted_data. The diploSHIC training model and training results will be stored in output_folder_path/train/model. The training summary statistics files will be stored in output_folder_path/train/model/training (training set) and output_folder_path/train/model/testing (validation set)."
    echo
    echo -e "Test mode: \nsh run_diploSHIC.sh test neutral_ms_file_path selective_sweep_ms_file_path outout_path hdf5_model_folder_path window_size"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/test/extracted_data. The 'hdf5_model_folder_path' should point to the folder that contains the hdf5 training model of diploSHIC. The testing results will be stored in output_folder_path/test/result."
    echo
    echo "NOTE: please add '/' at the end of each folder path."
    echo
    echo "Quick example:"
    echo "conda activate diploSHIC"
    echo "sh run_diploSHIC.sh train Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_result/ 128"
    echo "sh run_diploSHIC.sh test Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ Example_result/train/model/ 128"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

if [ ! -d $4 ]; then
	mkdir -p "$4""$1"/;
fi

# Train
if [ "$1" = "train" ]; then
	mkdir -p "$4""$1"/model;
	mkdir -p "$4""$1"/extracted_data;
	./convert -i $2 -m original -c bp -w $5 -s 5000 -l 100000 -r 5 -g 1 -o "$4""$1"/extracted_data/neutral.ms
	./convert -i $3 -m original -c bp -w $5 -s 5000 -l 100000 -r 5 -g 1 -o "$4""$1"/extracted_data/selsweep.ms
	sh ./SCRIPTS/diploSHIC_scripts/diploSHIC_training.sh "$4""$1"/extracted_data/neutral.ms "$4""$1"/extracted_data/selsweep.ms "$4""$1"/model;
	echo 'training finish';
	

# Test
elif [ "$1" = "test" ]; then
	mkdir -p "$4""$1"/result;
	mkdir -p "$4""$1"/extracted_data;
	./convert -i $2 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$4""$1"/extracted_data/neutral.ms
	./convert -i $3 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$4""$1"/extracted_data/selsweep.ms
	sh ./SCRIPTS/diploSHIC_scripts/diploSHIC_testing.sh "$4""$1"/extracted_data/neutral.ms "$4""$1"/extracted_data/selsweep.ms $5 "$4""$1"/result;
	echo 'done';
else
	echo 'Unknown mode';
fi
