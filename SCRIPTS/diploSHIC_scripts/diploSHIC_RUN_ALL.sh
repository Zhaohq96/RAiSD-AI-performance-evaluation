#!/bin/bash

for d in 1 2 3 4 5 6 
do
	sh /home/zhaoh1/Experiment-raisd-ai/SCRIPTS/diploSHIC_scripts/diploSHIC_Full.sh /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/train/BASE"$d"_P10000_W128.txt /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/train/TEST"$d"_P10000_W128.txt /home/zhaoh1/Experiment-raisd-ai/RESULTS/diploSHIC/D"$d"_128/model /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/test/BASE"$d"_W128.txt /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/test/TEST"$d"_W128.txt /home/zhaoh1/Experiment-raisd-ai/RESULTS/diploSHIC/D"$d"_128/results Dataset"$d";     
done

for d in 1 2 3 4 5 6 
do
	sh /home/zhaoh1/Experiment-raisd-ai/SCRIPTS/SURFDAWave_scripts/diploSHIC_Full.sh /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/train/BASE"$d"_P10000_W670.txt /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/train/TEST"$d"_P10000_W670.txt /home/zhaoh1/Experiment-raisd-ai/RESULTS/SURFDAWave/D"$d"_670/model /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/test/BASE"$d"_W670.txt /home/zhaoh1/Experiment-raisd-ai/DATASET-EXTRACT/D"$d"/test/TEST"$d"_W670.txt /home/zhaoh1/Experiment-raisd-ai/RESULTS/SURFDAWave/D"$d"_670/results Dataset"$d";     
done


cp D1/train/BASE2_P10000.txt D1/train/TEST2_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D1/train/;
cp D1/test/BASE2.txt D1/test/TEST2.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D1/test/;
cp D2/train/BASE48_P10000.txt D2/train/TEST48_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D2/train/;
cp D2/test/BASE48.txt D2/test/TEST48.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D2/test/;
cp D3/train/BASE61_P10000.txt D3/train/TEST61_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D3/train/;
cp D3/test/BASE61.txt D3/test/TEST61.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D3/test/;
cp D4/train/BASE70_P10000.txt D4/train/TEST70_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D4/train/;
cp D4/test/BASE70.txt D4/test/TEST70.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D4/test/;
cp D5/train/BASE92_P10000.txt D5/train/TEST92_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D5/train/;
cp D5/test/BASE92.txt D5/test/TEST92.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D5/test/;
cp D6/train/BASE96_P10000.txt D6/train/TEST96_P10000.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D6/train/;
cp D6/test/BASE96.txt D6/test/TEST96.txt /home/zhaoh1/Experiment-raisd-ai/raisd-ai-evaluation-datasets/D6/test/

for d in 1 2 3 4 5 6
do
	mv D"$d"/train/BASE* D"$d"/train/neutral.txt
	mv D"$d"/train/TEST* D"$d"/train/selection.txt
	mv D"$d"/test/BASE* D"$d"/test/neutral.txt
	mv D"$d"/test/TEST* D"$d"/test/selection.txt
done

for d in 1 2 3 4 5 6
do
	tar -czvf raisd-ai-evaluation-datasets-D"$d".tar.gz raisd-ai-evaluation-datasets/D"$d"
done

tar -czvf raisd-ai-evaluation-datasets.tar.gz raisd-ai-evaluation-datasets-D1.tar.gz raisd-ai-evaluation-datasets-D2.tar.gz raisd-ai-evaluation-datasets-D3.tar.gz raisd-ai-evaluation-datasets-D4.tar.gz raisd-ai-evaluation-datasets-D5.tar.gz raisd-ai-evaluation-datasets-D6.tar.gz 
