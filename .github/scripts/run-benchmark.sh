#!/bin/sh

set -eo pipefail

BENCHMARK_FILTER=$(echo ${BENCHMARK_FILTER} | xargs)
DATA_JSON_PREFIX=$(date +"%Y%m%d_%H%M%S")
export GOMP_CPU_AFFINITY="${CORE_LIST}"
export CUDA_VISIBLE_DEVICES="${GPU_LIST}"

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
    jq --arg run_id "${GITHUB_RUN_ID}" --arg config_ver "${CONFIG_VER}" \
       '.machine_info.circle_project_name="githubactions-benchmark-$config_ver" | .machine_info.circle_build_num=$run_id' \
       /output/${DATA_JSON_PREFIX}_${c}.json > /output/${DATA_JSON_PREFIX}_${c}.json.tmp
    mv /output/${DATA_JSON_PREFIX}_${c}.json.tmp /output/${DATA_JSON_PREFIX}_${c}.json
done
