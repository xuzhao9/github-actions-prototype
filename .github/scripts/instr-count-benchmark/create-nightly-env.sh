#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

wget -O - https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh |bash

conda create -y -q --name ${CONDA_ENV_NAME} python=${PYTHON_VERSION}
. activate ${CONDA_ENV_NAME}
conda init bash; conda run /bin/bash

# Install PyTorch nightly from pip
pip install --pre torch \
    -f https://download.pytorch.org/whl/nightly/${CUDA_VERSION}/torch_nightly.html
