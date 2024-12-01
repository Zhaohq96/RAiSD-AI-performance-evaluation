
#./diploSHIC_training.sh ../../DATASETS/TRAIN/train1_N.ms ../../DATASETS/TRAIN/train1_H.ms ../../MODELS/diploSHIC/M1_1500x2

#./diploSHIC_training.sh ../../DATASETS/TRAIN/train36_N.ms ../../DATASETS/TRAIN/train36_H.ms ../../MODELS/diploSHIC/M36_1500x2

#./diploSHIC_training.sh ../../DATASETS/TRAIN/train60_N.ms ../../DATASETS/TRAIN/train60_H.ms ../../MODELS/diploSHIC/M60_1500x2

time ./diploSHIC_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/diploSHIC/M1_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/diploSHIC/D1_M1 1 > diplorun1.txt

time ./diploSHIC_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset36_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/diploSHIC/M36_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/diploSHIC/D36_M36 1 > diplorun36.txt

time ./diploSHIC_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset60_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset60_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/diploSHIC/M60_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/diploSHIC/D60_M60 60 > diplorun60.txt

#./SURFDAWave_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset1_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/SURFDAWave/M1_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/SURFDAWave/D1_w_M1

#./SURFDAWave_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset36_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset36_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/SURFDAWave/M36_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/SURFDAWave/D36_M36

#./SURFDAWave_testing.sh /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset60_neutral.ms /home/sweepcnn/ASDEC_EVAL/DATASETS/TEST/dataset60_hard.ms /home/sweepcnn/ASDEC_EVAL/MODELS/SURFDAWave/M60_1500x2 /home/sweepcnn/ASDEC_EVAL/RESULTS/SURFDAWave/D60_M60
