#!/bin/sh

set -euo pipefail

# Sanity checks
if [[ ! -v GITHUB_RUN_ID ]]; then
    echo "GITHUB_RUN_ID is not set! Please check your environment variable. Stop."
    exit 1
fi

. ~/miniconda3/etc/profile.d/conda.sh
conda activate base

BENCHMARK_DATA="`pwd`/.data"
mkdir -p ${BENCHMARK_DATA}
BENCHMARK_FILENAME=${GITHUB_RUN_ID}_$(date +"%Y%m%d_%H%M%S").json

pytest test_bench.py --ignore_machine_config --setup-show --benchmark-sort=Name --benchmark-json=${BENCHMARK_ABS_FILENAME} -k "$PYTEST_FILTER"
TORCHBENCH_SCORE=$(python compute_score.py --configuration torchbenchmark/score/configs/v0/config-v0.yaml --benchmark_data_file ${BENCHMARK_ABS_FILENAME})
