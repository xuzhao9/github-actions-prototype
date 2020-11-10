#!/bin/sh

set -euo pipefail

# Root of this repo
REPO_ROOT=`pwd`/../
# Directory that stores the json results
RESULTS_DIR=${HOME}/benchmark-results
# Directory that stores the nightly figures
FIGURES_DIR=${HOME}/artifact-figures

# Run the Docker

# We allow each nightly build to be run multiple times
# We use the latest run for each nightly build to generate the figure

# Link the artifacts 
# rm ${FIGURES_DIR}/artifact-figure-latest.html
# ln -s ${FIGURES_DIR}/${LATEST_FIGURE} ${FIGURES_DIR}/artifact-figure-latest.html

