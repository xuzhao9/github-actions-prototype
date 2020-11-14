#!/bin/sh

set -euo pipefail

# Root of this repo
REPO_ROOT=`pwd`/../
# Directory that stores the json results
RESULTS_DIR=${HOME}/benchmark-results
# Directory that stores the nightly figures
FIGURES_DIR=${HOME}/artifact-figures

# TODO: We should allow each nightly build to be run multiple times
# And should use the latest run for each nightly build to generate the figure

# Link the latest artifacts 
# rm ${FIGURES_DIR}/artifact-figure-latest.html
# ln -s ${FIGURES_DIR}/${LATEST_FIGURE} ${FIGURES_DIR}/artifact-figure-latest.html

