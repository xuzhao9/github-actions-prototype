#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

conda init bash; conda run /bin/bash
cat $HOME/.bashrc
. $HOME/.bashrc
echo $PATH
conda activate ${CONDA_ENV_NAME}

# Run the instruction count benchmark
