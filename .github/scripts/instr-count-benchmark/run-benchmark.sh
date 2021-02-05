#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

# Run the instruction count benchmark
eval "$(${HOME}/miniconda/bin/conda shell.bash hook)" &> /dev/null
conda activate ${CONDA_ENV_NAME}
conda deactivate
