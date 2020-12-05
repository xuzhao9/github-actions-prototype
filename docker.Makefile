DOCKER_REGISTRY  = docker.io
DOCKER_ORG       = $(shell docker info 2>/dev/null | sed '/Username:/!d;s/.* //')
DOCKER_IMAGE     = pytorch
DOCKER_FULL_NAME = $(DOCKER_REGISTRY)/$(DOCKER_ORG)/$(DOCKER_IMAGE)

ifeq ("$(DOCKER_ORG)","")
$(warning WARNING: No docker user found using results from whoami)
DOCKER_ORG       = $(shell whoami)
endif

CUDA_VERSION     = 10.2
CUDNN_VERSION    = 7
BASE_RUNTIME     = ubuntu:18.04
BASE_DEVEL       = nvidia/cuda:$(CUDA_VERSION)-cudnn$(CUDNN_VERSION)-devel-ubuntu18.04

# The conda channel to use to install pytorch / torchvision
INSTALL_CHANNEL  = pytorch

PYTHON_VERSION   = 3.7
# Can be either official / dev
BUILD_TYPE       = dev
BUILD_PROGRESS   = auto
BUILD_ARGS       = --build-arg BASE_IMAGE=$(BASE_IMAGE) \
				   --build-arg PYTHON_VERSION=$(PYTHON_VERSION) \
				   --build-arg CUDA_VERSION=$(CUDA_VERSION) \
				   --build-arg INSTALL_CHANNEL=$(INSTALL_CHANNEL)
DOCKER_BUILD     = DOCKER_BUILDKIT=1 docker build --progress=$(BUILD_PROGRESS) --target $(BUILD_TYPE) -t $(DOCKER_FULL_NAME):$(DOCKER_TAG) $(BUILD_ARGS) .

PYTORCH_VERSION  = 1.5.1

.PHONY: all
all: devel-image

.PHONY: devel-image
devel-image: BASE_IMAGE := $(BASE_DEVEL)
devel-image: DOCKER_TAG := $(PYTORCH_VERSION)-devel
devel-image:
	$(DOCKER_BUILD)

.PHONY: runtime-image
runtime-image: BASE_IMAGE := $(BASE_RUNTIME)
runtime-image: DOCKER_TAG := $(shell git describe --tags)-runtime
runtime-image:
	$(DOCKER_BUILD)
	docker tag $(DOCKER_FULL_NAME):$(DOCKER_TAG) $(DOCKER_FULL_NAME):latest

.PHONY: clean
clean:
	-docker rmi -f $(shell docker images -q $(DOCKER_FULL_NAME))
