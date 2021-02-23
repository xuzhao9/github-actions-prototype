#!/bin/bash
set -e

# Sanity checks
if [[ ! -v GITHUB_RUN_ID ]]; then
    echo "GITHUB_RUN_ID is not set! Please check your environment variable. Stop."
    exit 1
fi

. ~/miniconda3/etc/profile.d/conda.sh
conda activate base

# conda install -y pytorch torchtext torchvision -c pytorch-nightly

# Changing to pip to work around https://github.com/pytorch/pytorch/issues/49375
function install_nightly {
    CUDA_VERSION=$1
    pip install -q numpy
    pip install -q --pre torch torchvision -f https://download.pytorch.org/whl/nightly/${CUDA_VERSION}/torch_nightly.html
    pip install -q --pre torchtext -f https://download.pytorch.org/whl/nightly/${CUDA_VERSION}/torch_nightly.html
}


# idiomatic parameter and option handling in sh
while test $# -gt 0
do
    case "$1" in
	10.2) install_nightly "cu102"
		;;
	11.0) install_nightly "cu110"
		;;
	*) echo "bad argument $1"; exit 1
	   ;;
    esac
    shift
done
