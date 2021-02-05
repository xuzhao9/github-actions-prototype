#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

. activate ${CONDA_ENV_NAME}
conda init bash; conda run /bin/bash

# Run the instruction count benchmark
