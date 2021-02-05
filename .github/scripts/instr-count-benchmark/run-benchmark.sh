#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

conda activate ${CONDA_ENV_NAME}

# Run the instruction count benchmark
