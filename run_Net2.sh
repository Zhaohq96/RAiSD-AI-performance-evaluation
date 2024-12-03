#!/bin/bash

show_help() {
    echo "Usage of run_Net2.sh"
    echo -e "\nsh run_Net2.sh input_folder_path output_folder_path window_size length target epoch"
    echo
    echo "The command will extract the given size of window (number of snps) from the center of the raw ms files, convert the extracted matrices into images and store them in output_folder_path/results. The training model will be stored in output_folder_path/results/model. The training results and testing results will be stored in output_folder_path/results/log."
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
    echo "conda activate Net2"
    echo "sh run_Net2.sh Example_dataset/ Example_result/ 128 100000 50000 10"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
    show_help
    exit 0
fi

rm -r "$2"
if [ ! -d $2 ]; then
	mkdir -p "$2";
fi

mkdir -p "$2"images/train/neutral;
mkdir -p "$2"images/train/selection;
mkdir -p "$2"images/test/neutral;
mkdir -p "$2"images/test/selection;
mkdir -p "$2"images/valid/neutral;
mkdir -p "$2"images/valid/selection;
mkdir -p "$2"results/log;
mkdir -p "$2"results/model;


input="$1"
./RAiSD-AI -n "Net2""${input%/}"TrainingData2DSNP -I $1train/neutral.ms -w $3 -L $4 -its $5 -op IMG-GEN -icl neutralTR -f -frm
./RAiSD-AI  -n "Net2""${input%/}"TrainingData2DSNP -I $1train/selsweep.ms -w $3 -L $4 -its $5 -op IMG-GEN -icl sweepTR -f

./RAiSD-AI -n "Net2""${input%/}"TestingData2DSNP -I $1test/neutral.ms -w $3 -L $4 -its $5 -op IMG-GEN -icl neutralTE -f -frm
./RAiSD-AI  -n "Net2""${input%/}"TestingData2DSNP -I $1test/selsweep.ms -w $3 -L $4 -its $5 -op IMG-GEN -icl sweepTE -f

mv "RAiSD_Images.""Net2""${input%/}"TrainingData2DSNP/neutralTR/* "$2"images/train/neutral;
mv "RAiSD_Images.""Net2""${input%/}"TrainingData2DSNP/sweepTR/* "$2"images/train/selection;

mv "RAiSD_Images.""Net2""${input%/}"TestingData2DSNP/neutralTE/* "$2"images/test/neutral;
mv "RAiSD_Images.""Net2""${input%/}"TestingData2DSNP/sweepTE/* "$2"images/test/selection;

# Get the total number of images in the source folder
source_folder="$2"images/train/neutral
total_images=$(ls "$source_folder"/*.{jpg,jpeg,png,gif} 2>/dev/null | wc -l)

# Calculate 20% of the total images (rounded down)
num_to_move=$((total_images * 20 / 100))

# Randomly select 20% of the images and move them
destination_folder="$2"images/valid/neutral
ls "$source_folder"/*.{jpg,jpeg,png,gif} 2>/dev/null | shuf | head -n "$num_to_move" | while read -r image; do
    mv "$image" "$destination_folder"
done

# Get the total number of images in the source folder
source_folder="$2"images/train/selection
total_images=$(ls "$source_folder"/*.{jpg,jpeg,png,gif} 2>/dev/null | wc -l)

# Calculate 20% of the total images (rounded down)
num_to_move=$((total_images * 20 / 100))

# Randomly select 20% of the images and move them
destination_folder="$2"images/valid/selection
ls "$source_folder"/*.{jpg,jpeg,png,gif} 2>/dev/null | shuf | head -n "$num_to_move" | while read -r image; do
    mv "$image" "$destination_folder"
done

python TOOLS/NET2/Code/main.py "$2" "$2"results/ $6

mv "RAiSD_Info.Net2""${input%/}"* "$2"results/log
mv "RAiSD_Images.Net2""${input%/}"* "$2"results
