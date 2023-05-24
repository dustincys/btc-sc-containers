FROM --platform=linux/x86_64 oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scAligners - Container with Cellranger"

# Set the working directory inside the container
WORKDIR /opt

ARG CELLRANGER_VERSION='7.1.0'

## Please change the link considering the 10x Genomics End User Software License Agreement
ARG CELLRANGER_URL="https://www.dropbox.com/s/c2d0yvw1muc5nzj/cellranger-${CELLRANGER_VERSION}.tar.gz?dl=0"
ENV PATH=/opt/cellranger-${CELLRANGER_VERSION}:$PATH

# Install FastQC
RUN --mount=type=cache,target=/var/cache/apt apt-get update && \
    apt-get install -y fastqc

# Install MultiQC
RUN --mount=type=cache,target=/root/.cache/pip pip3 install multiqc

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# CellRanger binaries
RUN wget ${CELLRANGER_URL} -O cellranger-${CELLRANGER_VERSION}.tar.gz
RUN tar -zxvf cellranger-${CELLRANGER_VERSION}.tar.gz \
    && rm -rf cellranger-${CELLRANGER_VERSION}.tar.gz

CMD  ["cellranger"]
