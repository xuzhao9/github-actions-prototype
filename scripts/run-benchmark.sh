#!/bin/sh

set -euo pipefail

# Parameters
CORE_LIST="4-47"
BENCHMARK_SRC=${HOME}/benchmark
TODAY=$(date +"%Y%m%d")
DATA_DIR=${HOME}/benchmark-results/${TODAY}

export GOMP_CPU_AFFINITY="${CORE_LIST}"
export CUDA_VISIBLE_DEVICES=0

# Use the latest pytorch image
TORCH_IMAGE=$(docker images | sed -n '2 p')
TORCH_IMAGE_ID=$(echo $TORCH_IMAGE | tr -s ' ' | cut -d' ' -f3)

echo "Running docker image ${TORCH_IMAGE_ID}"

pushd ${BENCHMARK_SRC}
mkdir -p ${DATA_DIR}

# Nvidia won't let this run in docker
sudo nvidia-smi -ac 5001,900

docker run \
       --volume="${BENCHMARK_SRC}:/benchmark" \
       --volume="${DATA_DIR}:/output" \
       --gpus=all \
       $TORCH_IMAGE_ID \
       bash /benchmark/run-docker.sh
