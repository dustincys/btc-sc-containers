FROM --platform=linux/x86_64 oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scAligners - Container with Cellranger"

ARG CELLRANGER_VERSION='7.1.0'

## Please change the link considering the 10x Genomics End User Software License Agreement
ARG CELLRANGER_URL="https://www.dropbox.com/s/c2d0yvw1muc5nzj/cellranger-${CELLRANGER_VERSION}.tar.gz?dl=0"
ENV PATH=/opt/cellranger-${CELLRANGER_VERSION}:$PATH

# Install basic requirments
RUN apt-get update && \
    apt-get install -y wget \
    fastqc

# CellRanger binaries
RUN wget cellranger-${CELLRANGER_VERSION}.tar.gz -O ${CELLRANGER_URL} \
    && tar xzf cellranger-${CELLRANGER_VERSION}.tar.gz \
    && rm -rf cellranger-${CELLRANGER_VERSION}.tar.gz \
    && mv cellranger-${CELLRANGER_VERSION} /opt/

WORKDIR /opt

CMD  ["cellranger"]