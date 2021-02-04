#!/bin/sh

set -xeuo pipefail

PYTORCH_GITHUB="https://github.com/pytorch/pytorch.git"
PYTORCH_SRC=pytorch

git clone -b nightly --single-branch $PYTORCH_GITHUB $PYTORCH_SRC

# Build the nightly docker
pushd $PYTORCH_SRC
# Docker full name is: ghcr.io/pytorch-nightly/pytorch:${PYTORCH_NIGHTLY_COMMIT}
PYTORCH_NIGHTLY_COMMIT=$(git log -1 --pretty=%B | head -1 | sed 's,.*(\([[:xdigit:]]*\)),\1,' | head -c 7)
make -f docker.Makefile \
     DOCKER_REGISTRY=ghcr.io \
     DOCKER_ORG=pytorch-nightly \
     DOCKER_TAG=${PYTORCH_NIGHTLY_COMMIT} \
     INSTALL_CHANNEL=pytorch-nightly BUILD_TYPE=official devel-image
popd
