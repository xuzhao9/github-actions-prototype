#!/bin/sh

set -euo pipefail

BENCHMARK_GITHUB="https://github.com/pytorch/benchmark.git"
BENCHMARK_SRC=${HOME}/benchmark
TODAY=$(date +"%Y%m%d")

# Checkout benchmark code
# if [ -d $BENCHMARK_SRC ]
# then
#     # Update the code
#     pushd $BENCHMARK_SRC && git pull
#     popd
# else
#     # Fetch the newest code
#     git clone $BENCHMARK_GITHUB $BENCHMARK_SRC
# fi

# Get the latest pytorch docker image
TORCH_LATEST=$(docker images | grep "pytorch\s" | head -n 1)
TORCH_ID=$(echo $TORCH_LATEST | tr -s ' ' | cut -d ' ' -f3)

pushd ${BENCHMARK_SRC}
sed -i 's,ec2-user/pytorch,$TORCH_ID' docker/Dockerfile
docker build -t $(id -un)/pytorch-benchmark:$TODAY docker
sed -i 's,$TORCH_ID,ec2-user/pytorch' docker/Dockerfile
