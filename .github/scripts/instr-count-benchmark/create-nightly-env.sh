#!/bin/sh

set -xueo pipefail

BASEDIR=$(dirname $0)
set -a;
source ${BASEDIR}/config.env
set +a;

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p ${HOME}/miniconda

eval "$(${HOME}/miniconda/bin/conda shell.bash hook)"

conda init bash; conda run /bin/bash

conda create -y -q --name ${CONDA_ENV_NAME} python=${PYTHON_VERSION}
# Install PyTorch nightly from pip
conda activate ${CONDA_ENV_NAME}
pip install --pre torch \
    -f https://download.pytorch.org/whl/nightly/${CUDA_VERSION}/torch_nightly.html
