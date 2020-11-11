#!/bin/sh

set -euo pipefail

PYTORCH_SRC=${HOME}/code/pytorch

# Checkout pytorch code
mkdir -p ~/code
if [ -d $PYTORCH_SRC ]
then
    # Update the code
    pushd $PYTORCH_SRC && git pull
    popd
else
    # Fetch the newest code
    git clone https://github.com/pytorch/pytorch.git $PYTORCH_SRC
fi

# Build the nightly docker
pushd $PYTORCH_SRC
make -f docker.Makefile INSTALL_CHANNEL=pytorch-nightly BUILD_TYPE=official devel-image
popd

