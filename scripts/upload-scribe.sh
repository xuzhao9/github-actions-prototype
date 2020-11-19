#!/bin/sh

# [FB Internal] Upload every json file to Scribe

set -eo pipefail

pushd /workspace/benchmark/score

TORCHBENCH_SCORE=$(python compute_score.py --benchmark_data_dir /output | awk 'NR>2' )

IFS=$'\n'
for line in $TORCHBENCH_SCORE ; do
    JSON_NAME=$(echo $line | tr -s " " | cut -d " " -f 1)
    SCORE=$(echo $line | tr -s " " | cut -d " " -f 2)
    python3 ./scripts/upload_scribe.py --pytest_bench_json /output/${JSON_NAME} \
            --torchbench_score $SCORE
done
