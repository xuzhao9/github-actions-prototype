#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

# Run the instruction count benchmark
eval "$(${CONDA_PREFIX}/bin/conda shell.bash hook)"
conda activate ${CONDA_ENV_NAME}
conda deactivate
