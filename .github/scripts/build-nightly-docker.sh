#!/bin/sh

set -euo pipefail

PYTORCH_GITGHUB="https://github.com/pytorch/pytorch.git"
PYTORCH_SRC=pytorch

git clone -b master --single-branch $PYTORCH_GITHUB $PYTORCH_SRC

# Build the nightly docker
pushd $PYTORCH_SRC
make -f docker.Makefile \
     INSTALL_CHANNEL=pytorch-nightly BUILD_TYPE=official devel-image
popd
