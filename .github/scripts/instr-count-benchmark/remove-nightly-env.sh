#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;
eval "$(${CONDA_PREFIX}/bin/conda shell.bash hook)"
# ========== END of prelude

conda env remove --name ${CONDA_ENV_NAME}
