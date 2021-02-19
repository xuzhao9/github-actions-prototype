#!/bin/sh

sudo apt-get -y update
sudo apt-get -y remove linux-image-generic linux-headers-generic linux-generic docker-ce
sudo apt-get -y install \
  linux-headers-$(uname -r) \
  linux-image-generic \
  moreutils \
  docker-ce=5:18.09.4~3-0~ubuntu-xenial \
  nvidia-container-runtime=2.0.0+docker18.09.4-1 \
  nvidia-docker2=2.0.3+docker18.09.4-1 \
  expect-dev

DRIVER_FN="NVIDIA-Linux-x86_64-440.59.run"
wget "https://s3.amazonaws.com/ossci-linux/nvidia_driver/$DRIVER_FN"
sudo /bin/bash "$DRIVER_FN" -s --no-drm || (sudo cat /var/log/nvidia-installer.log && false)
nvidia-smi
