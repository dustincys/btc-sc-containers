FROM --platform=linux/x86_64 ubuntu:20.04

LABEL maintainer="Andre Fonseca" \
    description="scRBase - The base container for versioning the single-cell R and Python dependencies"

# Set the working directory inside the container
WORKDIR /opt

# Timezone settings
ENV TZ=US/Central
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install system packages required for Python and Micromamba
RUN --mount=type=cache,target=/var/cache/apt apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        wget \
        curl \
        bzip2 \
        libglib2.0-0 \
        libxext6 \
        libsm6 \
        libxrender1

# Install git
RUN apt-get install -y git

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Download and install Micromamba
RUN curl -Ls https://micro.mamba.pm/api/micromamba/linux-64/latest | tar -xvj bin/micromamba && \
    mv bin/micromamba /usr/local/bin && \
    rm -rf bin

# Starting enviroment
RUN micromamba shell init --shell=bash --prefix=/root/micromamba

# Install micromamba modules
RUN micromamba install -y python=3.8 -n base -c conda-forge jupyter
RUN micromamba install -y python=3.8 -n base -c conda-forge r-base

RUN micromamba clean --all --yes

# Activate the environment
ENV PATH=/root/micromamba/bin:$PATH
RUN echo "micromamba activate" >> ~/.bashrc

CMD [ "/bin/bash", "-l", "-c" ]
