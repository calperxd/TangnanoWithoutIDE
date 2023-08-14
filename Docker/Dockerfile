FROM ubuntu:20.04

LABEL gabrielcalperseabra="gcalperseabra@gmail.com"

ARG DEBIAN_FRONTEND=noninteractive


RUN apt-get update && \
    apt-get install -y \
    iverilog \
    gtkwave \
    vim \
    git \
    wget \
    curl \
    python3 \
    python3-pip \
    python3-setuptools \
    cmake \
    libboost-program-options-dev \
    libboost-iostreams-dev \
    libboost-thread-dev \
    libeigen3-dev \
    libftdi1-dev \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y \
    build-essential clang bison flex \
	libreadline-dev gawk tcl-dev libffi-dev git \
	graphviz xdot pkg-config python3 libboost-system-dev \
	libboost-python-dev libboost-filesystem-dev zlib1g-dev

RUN pip install apycula
ENV PATH $PATH:/usr/local/bin



COPY * /app

WORKDIR /app

CMD ["/bin/bash"]
