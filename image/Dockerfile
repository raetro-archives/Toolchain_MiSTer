################################################################################
##  __  __ _ ___ _____        _  __    _  _   _                               ##
## |  \/  (_) __|_   _|__ _ _| |/ /  _| \| | (_)___                           ##
## | |\/| | \__ \ | |/ -_) '_| ' < || | .` |_| / _ \                          ##
## |_|  |_|_|___/ |_|\___|_| |_|\_\_,_|_|\_(_)_\___/            MiSTerKuN.io  ##
################################################################################
## Project       : MiSTer FPGA
## Module        : Native ARMv7 C/C++ Toolchain for MiSTer HPS
## Purpose       : Provide easy toolchain to build applications, kernel, etc.
## Author        : Marcus Andrade <Boogermann>
## Creation Date : 20191231
################################################################################
## Copyright (c) 2019 Marcus Andrade
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in
## all copies or substantial portions of the Software.
################################################################################
## Change History [date(YYYYMMDD) Who: What]
##  20200109 MJA: moved sdl libraries to toolchain-sdl
##  20191231 MJA: first release
################################################################################
FROM arm32v7/debian:stretch-slim
MAINTAINER Marcus Andrade "marcus@misterkun.io"

# Environment Variable
ENV DEBIAN_FRONTEND=noninteractive
ENV MISTER_ROOT=/mister
ENV MISTER_SD=/media/fat
ENV BOOST_ROOT=/usr/include/boost

# Switches for Optimization
ENV CFLAGS="-mcpu=cortex-a9 -mtune=cortex-a9 -mfloat-abi=hard -march=armv7-a -mfpu=neon"

# Core Developement Packages
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	autoconf \
	automake \
	bash-completion \
	bison \
	build-essential \
	ca-certificates \
	checkinstall \
	curl \
	flex \
	gdb \
	git \
	iputils-ping \
	less \
	libc-dev \
	libcurl4-openssl-dev \
	libelf-dev \
	libfreetype6-dev \
	libgmp3-dev \
	libjsoncpp-dev \
	liblz4-tool \
	libmpc-dev \
	libmpfr-dev \
	libncurses5-dev \
	libpcap-dev \
	libreadline-dev \
	libssl-dev \
	libtcmalloc-minimal4 \
	libtool \
	libtool-bin \
	libusb-dev \
	libusb-1.0-0-dev \
	locales \
	mlocate \
	nano \
	nasm \
	openssh-client \
	p7zip \
	python3-pip \
	pkg-config \
	software-properties-common \
	sshpass \
	sudo \
	tcl \
	texinfo \
	tree \
	unzip \
	wget \
	xz-utils \
	zlib1g-dev \
	--no-install-recommends && \
	## Make sure we leave any X11 related library behind
	apt-get purge -y 'libx11*' x11-common libxt6 && \
	apt autoremove -y && \
	rm -r /var/lib/apt/lists/*

# Compilers Envoirment Shortcuts.
ENV AS=as \
    AR=ar \
    CC=gcc \
    CPP=cpp \
    CXX=g++ \
    LD=ld \
    FC=gfortran

# Set System Locales
RUN echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Base Directories
RUN mkdir -p "${MISTER_ROOT}" "${MISTER_SD}" "${BOOST_ROOT}" && \
	chmod -R 777 "$MISTER_ROOT" && \
	chmod -R 777 "$MISTER_SD"

# Install CMAKE from Source
ENV CMAKE_VERSION="3.16.2"
RUN mkdir -p /tmp/cmake && wget -qO- https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz | tar --strip-components=1 -xz -C /tmp/cmake
RUN cd /tmp/cmake && ./bootstrap && make -j$(nproc) && make install && cd / && rm -rf /tmp/cmake

# Install Boost C++ Libraries
ENV BOOST_VERSION="1.72.0"
ENV BOOST_VERSION_="1_72_0"
RUN wget -qO- https://dl.bintray.com/boostorg/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_}.tar.gz | tar --strip-components=1 -xz -C ${BOOST_ROOT}

# Fix some core dependencies without rebuilding all layers
RUN apt-get update && apt-get upgrade -y && \
	apt-get install -y gettext libglib2.0-dev \
	libltdl-dev autopoint libudev-dev udev \
	libdbus-1-dev libdbus-glib-1-dev intltool \
	autogen shtool \
	--no-install-recommends && \
	rm -r /var/lib/apt/lists/*

# Add CXXFLAGS
ENV CXXFLAGS="-mcpu=cortex-a9 -mtune=cortex-a9 -mfloat-abi=hard -march=armv7-a -mfpu=neon"
ENV MAKEFLAGS="-j$(nproc)"

# Set Volume and Workdir
VOLUME /mister
WORKDIR /mister

# Bash Settings
RUN echo "export HISTTIMEFORMAT='%d/%m/%y %T '" >> ~/.bashrc && \
    echo "export PS1='\[\e[0;36m\]\u\[\e[0m\]@\[\e[0;33m\]\h\[\e[0m\]:\[\e[0;35m\]\w\[\e[0m\]\$ '" >> ~/.bashrc && \
    echo "alias ll='ls -lah'" >> ~/.bashrc && \
    echo "alias ls='ls --color=auto'" >> ~/.bashrc

# Metadata Params
ARG BUILD_DATE
ARG VCS_REF
ARG BUILD_VERSION

# Metadata
LABEL \
	org.label-schema.schema-version="1.0" \
	org.label-schema.vendor="MiSTerKüN" \
	org.label-schema.name="misterkun/toolchain" \
	org.label-schema.description="ARMv7 C/C++ Toolchain for MiSTer FPGA" \
	org.label-schema.url="https://github.com/misterkun-io/toolchain_MiSTer" \
	org.label-schema.vcs-url="https://github.com/misterkun-io/toolchain_MiSTer.git" \
	org.label-schema.build-date=$BUILD_DATE \
	org.label-schema.vcs-ref=$VCS_REF \
	org.label-schema.version=$BUILD_VERSION \
	org.label-schema.docker.cmd="docker run -it --rm -v ${pwd}:/mister misterkun/toolchain"

CMD ["/bin/bash"]
