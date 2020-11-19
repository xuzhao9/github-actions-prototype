#!/bin/sh

# [FB Internal] Upload every json file to Scribe

set -eo pipefail

pushd /workspace/benchmark

TORCHBENCH_SCORE=$(python score/compute_score.py --benchmark_data_dir /output)

find /output -name ".json" -type f -exec \
     python3 ./scripts/upload_scribe.py --pytest_bench_json {} --torchbench_score $TORCHBENCH_SCORE \;
