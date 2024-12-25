#!/bin/bash

# Install environment
sh install_environment.sh fast-nn

# Download dataset
sh download_dataset.sh mild-bottleneck-1K

# Process dataset
sh process_dataset.sh fast-nn mild-bottleneck-1K

# Delete dataset
sh delete_dataset.sh mild-bottleneck-1K

# Remove environment
sh remove_environment.sh fast-nn
