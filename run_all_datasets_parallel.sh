#!/bin/bash

# This is a script to reproduce the evaluation of RAiSD-AI paper automatically.

# Datasets download links
# Mild bottleneck: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_mild_bottleneck/27908139?file=50811243
# Severe bottleneck: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_severe_bottleneck/27909696?file=50817474
# Recent migration: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_rececnt_migration/27909744?file=50817546
# Old migration: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_old_migration/27909774?file=50817612
# Low intensity recombination hotspot: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_low_intensity_recombination_hotspot/27936102?file=50901324
# High intensity recombination hotspot: https://figshare.com/articles/dataset/raisd-ai_evaluation_dataset_high_intensity_recombination_hotspot/27936099?file=50901303


# Download datasets
wget -O dataset-mild-bottleneck.tar.gz https://figshare.com/ndownloader/files/50811243;
wget -O dataset-severe-bottleneck.tar.gz https://figshare.com/ndownloader/files/50817474;
wget -O dataset-recent-migration.tar.gz https://figshare.com/ndownloader/files/50817546;
wget -O dataset-old-migration.tar.gz https://figshare.com/ndownloader/files/50817612;
wget -O dataset-low-intensity-recombination-hotspot.tar.gz https://figshare.com/ndownloader/files/51217295;
wget -O dataset-high-intensity-recombination-hotspot.tar.gz https://figshare.com/ndownloader/files/51217298;

# Uncompress datasets
tar -xzvf dataset-mild-bottleneck.tar.gz;
tar -xzvf dataset-severe-bottleneck.tar.gz;
tar -xzvf dataset-recent-migration.tar.gz;
tar -xzvf dataset-old-migration.tar.gz;
tar -xzvf dataset-low-intensity-recombination-hotspot.tar.gz;
tar -xzvf dataset-high-intensity-recombination-hotspot.tar.gz;

# Evaluate datasets by running run_all_tools.sh
bash run_all_tools.sh dataset-mild-bottleneck/ result_mild_bottleneck/ mild_bottleneck;
bash run_all_tools.sh dataset-severe-bottleneck/ result_severe_bottleneck/ severe_bottleneck;
bash run_all_tools.sh dataset-recent-migration/ result_recent_migration/ recent_migration;
bash run_all_tools.sh dataset-old-migration/ result_old_migration/ old_migration;
bash run_all_tools.sh dataset-low-intensity-recombination-hotspot/ result_low_intensity_recombination_hotspot/ low_recombination;
bash run_all_tools.sh dataset-high-intensity-recombination-hotspot/ result_high_intensity_recombination_hotspot/ high_recombination;
