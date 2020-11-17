#!/bin/sh

set -euo pipefail

PYTORCH_GITGHUB="https://github.com/pytorch/pytorch.git"
PYTORCH_SRC=${HOME}/pytorch

# Checkout pytorch code
if [ -d $PYTORCH_SRC ]
then
    # Update the code
    pushd $PYTORCH_SRC && git pull origin master
    popd
else
    # Fetch the newest code
    git clone $PYTORCH_GITHUB $PYTORCH_SRC
fi

# Build the nightly docker
pushd $PYTORCH_SRC
sed -i 's,3.8,3.7,' Dockerfile
make -f docker.Makefile PYTHON_VERSION=3.7 INSTALL_CHANNEL=pytorch-nightly BUILD_TYPE=official devel-image
popd

