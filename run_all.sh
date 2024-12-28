#!/bin/bash

# Install environment
bash install_environment.sh fast-nn

# Download dataset
bash download_dataset.sh example

# Process dataset
bash process_dataset.sh fast-nn example

# Delete dataset
bash delete_dataset.sh example

# Remove environment
bash remove_environment.sh fast-nn
