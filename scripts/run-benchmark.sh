#!/bin/sh

set -euo pipefail

# Parameters
CORE_LIST="4-47"
BENCHMARK_SRC=${HOME}/benchmark
DATA_DIR=${BENCHMARK_SRC}/benchmark-results
TODAY=$(date +"%Y%m%d")

export GOMP_CPU_AFFINITY="${CORE_LIST}"
export CUDA_VISIBLE_DEVICES=0

# Use the latest pytorch image
TORCH_IMAGE=$(docker images | head -n 2)
TORCH_IMAGE_ID=""
if [[ TORCH_IMAGE == *pytorch* ]]; then
    TORCH_IMAGE_ID=$(echo $TORCH_IMAGE | tr -s ' ' | cut -d' ' -f3)
else
    echo "Can't find a pre-built pytorch Docker image on this machine!"
    exit 1;
fi

pushd ${BENCHMARK_SRC}
mkdir -p ${DATA_DIR}/${TODAY}

# Nvidia won't let this run in docker
sudo nvidia-smi -ac 5001,900

docker run \
       --volume="${BENCHMARK_SRC}:/benchmark" \
       --volume="${DATA_DIR}/${TODAY}:/output" \
       --gpus=all \
       $TORCH_IMAGE_ID \
       bash /benchmark/run-docker.sh
