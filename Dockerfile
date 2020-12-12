FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
  binutils-arm-none-eabi \
  build-essential \
  cmake \
  gcc-arm-none-eabi \
  git \
  libboost-all-dev \
  libftdi1-dev \
  libhidapi-dev \
  libnewlib-arm-none-eabi \
  libusb-1.0-0-dev \
  pkg-config \
  python3-pip \
  sudo \
  wget

# get user id from build arg, so we can have read/write access to directories
# mounted inside the container. only the UID is necessary, UNAME just for
# cosmetics
ARG UID=1010
ARG UNAME=builder

RUN useradd --uid $UID --create-home --user-group ${UNAME} && \
    echo "${UNAME}:${UNAME}" | chpasswd && adduser ${UNAME} sudo

USER ${UNAME}

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN pip3 install --user intelhex
ENV PATH /home/${UNAME}/.local/bin:$PATH

WORKDIR /mnt/workspace
