#!/bin/bash

# Install environment
sh Install_environment.sh surfdawave

# Download dataset
#sh download_dataset.sh low-intensity-recombination-hotspot-1K

# Process dataset
sh process_dataset.sh surfdawave low-intensity-recombination-hotspot-1K

# Delete dataset
#sh delete_dataset.sh low-intensity-recombination-hotspot-1K

# Remove environment
#sh remove_environment.sh fast-nn
