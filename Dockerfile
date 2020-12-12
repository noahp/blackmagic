FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get -y install \
  build-essential \
  cmake \
  gcc-arm-none-eabi binutils-arm-none-eabi libnewlib-arm-none-eabi \
  git \
  libboost-all-dev \
  libhidapi-dev \
  libusb-1.0-0-dev \
  pkg-config \
  python3-pip \
  sudo \
  wget

ARG LIBFTDI_SHA256=a6ea795c829219015eb372b03008351cee3fb39f684bff3bf8a4620b558488d6
RUN wget http://www.intra2net.com/en/developer/libftdi/download/libftdi1-1.2.tar.bz2 && \
  echo "${LIBFTDI_SHA256} libftdi1-1.2.tar.bz2" | sha256sum --check --status && \
  tar -xjf libftdi1-1.2.tar.bz2 && \
  cd libftdi1-1.2 && \
  mkdir build && \
  cd build && \
  cmake ../ && \
  make -j6 && \
  sudo make install

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
