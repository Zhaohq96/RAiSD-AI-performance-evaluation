#!/bin/bash

for d in 2 48
do
       /home/sweepcnn/ASDEC_EVAL/convert -i /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000/D"$d"/train/BASE"$d".txt -m original -c bp -w 670 -s 5000 -l 100000 -r 5 -g 1 -o /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/train/BASE"$d"_W670.txt;
       /home/sweepcnn/ASDEC_EVAL/convert -i /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000/D"$d"/train/TEST"$d".txt -m original -c bp -w 670 -s 5000 -l 100000 -r 5 -g 1 -o /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/train/TEST"$d"_W670.txt;
       /home/sweepcnn/ASDEC_EVAL/convert -i /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000/D"$d"/test/BASE"$d".txt -m original -c bp -w 670 -s 5000 -l 100000 -r 5 -g 1 -o /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/test/BASE"$d"_W670.txt;
       /home/sweepcnn/ASDEC_EVAL/convert -i /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000/D"$d"/test/TEST"$d".txt -m original -c bp -w 670 -s 5000 -l 100000 -r 5 -g 1 -o /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/test/TEST"$d"_W670.txt;

        sh /home/sweepcnn/ASDEC_EVAL/SCRIPTS/SURFDAWave_scripts/SURFDAWave_Full.sh /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/train/BASE"$d"_W670.txt /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/train/TEST"$d"_W670.txt /home/sweepcnn/ASDEC_EVAL/SJOERD-RESULTS/SURFDAWave/D"$d"_670_1000/model /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/test/BASE"$d"_W670.txt /home/sweepcnn/ASDEC_EVAL/DATASET-SWEEPNET-P50000-EXTRACT/D"$d"/test/TEST"$d"_W670.txt /home/sweepcnn/ASDEC_EVAL/SJOERD-RESULTS/SURFDAWave/D"$d"_670_1000/results Dataset"$d";
done
