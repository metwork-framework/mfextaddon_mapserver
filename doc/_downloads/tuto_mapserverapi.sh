#!/bin/bash

# Activate MFEXT environment
MFEXT_HOME=/opt/metwork-mfext
export MFEXT_HOME
source ${MFEXT_HOME}/share/interactive_profile

# Load the python3_mapserverapi@mfext layer and run the mapserverapi.py script
layer_wrapper --layers=python3_mapserverapi@mfext -- python tuto_mapserverapi.py