#!/bin/sh

# [FB Internal] Upload every json file to Scribe

set -eo pipefail

if [[ ! -v SCRIBE_GRAPHQL_ACCESS_TOKEN ]]; then
    echo "SCRIBE_GRAPHQL_ACCESS_TOKEN is not set! Please check your environment variable. Stop."
    exit 1
fi

pushd /workspace/benchmark/score

# Generate the benchmark config
python generate_score_config.py --specification score.yml \
       --normalization_data $(find /output -name "*.json" | head -n 1) \
       --output_file benchmark_config.json \
       --target_score 1000

TORCHBENCH_SCORE=$(python compute_score.py --configuration benchmark_config.json --benchmark_data_dir /output | awk 'NR>2' )
mv benchmark_config.json /output

IFS=$'\n'
for line in $TORCHBENCH_SCORE ; do
    JSON_NAME=$(echo $line | tr -s " " | cut -d " " -f 1)
    SCORE=$(echo $line | tr -s " " | cut -d " " -f 2)
    python3 ../scripts/upload_scribe.py --pytest_bench_json /output/${JSON_NAME} \
            --torchbench_score $SCORE
done

popd
