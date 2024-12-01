#!/bin/bash

if [ ! -d $5 ]; then
	mkdir -p "$5";
fi

show_help() {
    echo "Usage of run_T-REx.sh"
    echo
    echo -e "sh run_T-REx.sh training_neutral_ms_file_path training_selective_sweep_ms_file_path testing_neutral_ms_file_path testing_selective_sweep_ms_file_path outout_folder_path window_size number_of_training simulations number_of_testing_simulations"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files and store the new files in output_folder_path/extracted_data. The processed ms files of training and testing sets will be stored in output_folder_path/MS_files_train and output_folder_path/MS_files_test, respectively. The folder of output_folder_path/CVF_files contains the cvf files converted from the processed ms files. The testing results will be stored in output_folder_path/Results"
    echo
    echo "NOTE: please add '/' at the end of each folder path and the training sets and testing sets should be balanced sets (same number of simulations for each class)."
    echo
    echo "Quick example:"
    echo "conda activate T-REx"
    echo "sh run_T-REx.sh Example_dataset/train/neutral.ms Example_dataset/train/selsweep.ms Example_dataset/test/neutral.ms Example_dataset/test/selsweep.ms Example_result/ 128 20 20"
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    show_help
    exit 0
fi

mkdir -p "$5"MS_files_train;
mkdir -p "$5"MS_files_test;
mkdir -p "$5"CVF_files;
mkdir -p "$5"Results;
mkdir -p "$5"extracted_data;
./convert -i $1 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$5"extracted_data/neutral_train.ms
./convert -i $2 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$5"extracted_data/selsweep_train.ms
./convert -i $3 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$5"extracted_data/neutral_test.ms
./convert -i $4 -m original -c bp -w $6 -s 5000 -l 100000 -r 5 -g 1 -o "$5"extracted_data/selsweep_test.ms

# Prepare the .ms file for T-REx
python TOOLS/T-REx/split.py -i "$5"extracted_data/neutral_train.ms -o "$5"MS_files_train -f neut
python TOOLS/T-REx/split.py -i "$5"extracted_data/selsweep_train.ms -o "$5"MS_files_train -f sweep
python TOOLS/T-REx/split.py -i "$5"extracted_data/neutral_test.ms -o "$5"MS_files_test -f neut
python TOOLS/T-REx/split.py -i "$5"extracted_data/selsweep_test.ms -o "$5"MS_files_test -f sweep

# Data preprocessing
echo 'Time of preprocessing the training set is:' > "$5"Results/Results.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python3 TOOLS/T-REx/train_ms.py $7 1 "$5"MS_files_train/
python3 TOOLS/T-REx/train_ms.py $7 0 "$5"MS_files_train/
python3 TOOLS/T-REx/parse_train.py $7 1 "$5"MS_files_train/ "$5"CVF_files/
python3 TOOLS/T-REx/parse_train.py $7 0 "$5"MS_files_train/ "$5"CVF_files/
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> "$5"Results/Results.txt

echo 'Time of preprocessing the testing set is:' >> "$5"Results/Results.txt
start=$(date +"%Y-%m-%d %H:%M:%S");
python3 TOOLS/T-REx/test_ms.py $8 1 "$5"MS_files_test/
python3 TOOLS/T-REx/test_ms.py $8 0 "$5"MS_files_test/
python3 TOOLS/T-REx/parse_test.py $8 1 "$5"MS_files_test/ "$5"CVF_files/
python3 TOOLS/T-REx/parse_test.py $8 0 "$5"MS_files_test/ "$5"CVF_files/
end=$(date +"%Y-%m-%d %H:%M:%S");
start_s=$(date -d "$start" +%s);
end_s=$(date -d "$end" +%s);
echo "$((end_s-start_s)) " >> "$5"Results/Results.txt

# Train and test
Rscript TOOLS/T-REx/TD.R 5 $7 $7 $8 $8 "$5"CVF_files/ "$5"Results/

echo 'Elastic net predicting accuracy:' >> "$5"Results/Results.txt
python3 TOOLS/T-REx/calculate_acc.py "$5"Results/Class_EN.csv >> "$5"Results/Results.txt
echo 'Random forest predicting accuracy:' >> "$5"Results/Results.txt
python3 TOOLS/T-REx/calculate_acc.py "$5"Results/Class_RF.csv >> "$5"Results/Results.txt
echo 'SVM predicting accuracy:' >> "$5"Results/Results.txt
python3 TOOLS/T-REx/calculate_acc.py "$5"Results/Class_SVM.csv >> "$5"Results/Results.txt
