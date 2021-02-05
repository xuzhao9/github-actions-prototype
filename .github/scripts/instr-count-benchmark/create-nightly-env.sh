#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b

conda create -y -q --name ${CONDA_ENV_NAME} python=${PYTHON_VERSION}
conda init bash; conda run /bin/bash
. ~/.bashrc; conda activate
conda activate ${CONDA_ENV_NAME}

# Install PyTorch nightly from pip
pip install --pre torch \
    -f https://download.pytorch.org/whl/nightly/${CUDA_VERSION}/torch_nightly.html
