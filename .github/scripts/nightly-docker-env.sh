

DOCKER_REGISTRY=ghcr.io
DOCKER_ORG=pytorch-nightly
# Must run on the nightly branch
PYTORCH_NIGHTLY_COMMIT=$(git log -1 --pretty=%B | head -1 | sed 's,.*(\([[:xdigit:]]*\)),\1,' | head -c 7)

