#!/bin/sh

set -xeuo pipefail

PYTORCH_GITHUB="https://github.com/pytorch/pytorch.git"
PYTORCH_SRC=pytorch

# Checkout the nightly branch and enter the directory
git clone -b master --single-branch $PYTORCH_GITHUB $PYTORCH_SRC
pushd $PYTORCH_SRC
git remote -v

############ End of the prelude

git fetch origin nightly
git checkout -b nightly origin/nightly
PYTORCH_NIGHTLY_COMMIT=$(git log -1 --pretty=%B origin/nightly | head -1 | \
                             sed 's,.*(\([[:xdigit:]]*\)),\1,' | head -c 7)

# Build PyTorch Nightly Docker
# Full name: ghcr.io/pytorch-nightly/pytorch:${PYTORCH_NIGHTLY_COMMIT}
make -f docker.Makefile \
     DOCKER_REGISTRY=ghcr.io \
     DOCKER_ORG=pytorch-nightly \
     DOCKER_TAG=${PYTORCH_NIGHTLY_COMMIT} \
     INSTALL_CHANNEL=pytorch-nightly BUILD_TYPE=official devel-image
popd

# Push the nightly docker to GitHub Container Registry
make -f docker.Makefile \
     DOCKER_REGISTRY=ghcr.io \
     DOCKER_ORG=pytorch-nightly \
     DOCKER_TAG=${PYTORCH_NIGHTLY_COMMIT} \
     devel-push

