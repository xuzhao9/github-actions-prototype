#!/bin/sh

set -euo pipefail

# Parameters
RUN_SCRIPT=$1
TODAY=$(date +"%Y%m%d")
DATA_DIR=${HOME}/benchmark-results/${TODAY}_gh${GITHUB_RUN_ID}

export CUDA_VISIBLE_DEVICES=0

# Use the latest pytorch image
TORCH_IMAGE=$(docker images | grep "pytorch-benchmark" | sed -n '1 p')
TORCH_IMAGE_ID=$(echo $TORCH_IMAGE | tr -s ' ' | cut -d' ' -f3)

echo "Running pytorch-benchmark image ${TORCH_IMAGE_ID}"

mkdir -p ${DATA_DIR}

# Nvidia won't let this run in docker
sudo nvidia-smi -ac 5001,900

docker run \
       --env GITHUB_RUN_ID \
       --volume="${PWD}:/runner" \
       --volume="${DATA_DIR}:/output" \
       --gpus=all \
       $TORCH_IMAGE_ID \
       bash ${RUN_SCRIPT}

echo "Benchmark finished successfully. Output data dir is benchmark-results/${TODAY}_gh${GITHUB_RUN_ID}."

