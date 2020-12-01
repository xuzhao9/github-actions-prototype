#!/bin/sh

set -eo pipefail

NUM_ITER=1
NUM_ROUNDS=20
DATA_JSON_PREFIX=$(date +"%Y%m%d_%H%M%S")
# BENCHMARK_FILTER="(not slomo)"
BENCHMARK_FILTER="(BERT_pytorch)"

# This machine has 16 physical cores, we use 12 of them to test
CORE_LIST="4-15"
export GOMP_CPU_AFFINITY="${CORE_LIST}"
export CUDA_VISIBLE_DEVICES=0

NO_TURBO_FILE="/sys/devices/system/cpu/intel_pstate/no_turbo"

conda init bash; conda run /bin/bash

if [[ -e ${NO_TURBO_FILE} ]]; then
    sh -c "echo 1 > ${NO_TURBO_FILE}"
fi

pushd /workspace/benchmark

for c in $(seq 1 $NUM_ITER); do
    echo "Run pytorch/benchmark for ${TORCH_VER} iter ${c}"
    taskset -c "${CORE_LIST}" pytest test_bench.py -k "${BENCHMARK_FILTER}" --benchmark-min-rounds "${NUM_ROUNDS}" \
                              --benchmark-json /output/${DATA_JSON_PREFIX}_${c}.json
    # Fill in circle_build_num and circle_project_reponame
    jq --arg run_id "${GITHUB_RUN_ID}" '.machine_info.circle_project_name="githubactions-benchmark" | .machine_info.circle_build_num=$run_id' \
       /output/${DATA_JSON_PREFIX}_${c}.json > /output/${DATA_JSON_PREFIX}_${c}.json.tmp
    mv /output/${DATA_JSON_PREFIX}_${c}.json.tmp /output/${DATA_JSON_PREFIX}_${c}.json
done