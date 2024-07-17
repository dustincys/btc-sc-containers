FROM --platform=linux/x86_64 ubuntu:20.04

LABEL maintainer="Yanshuo Chu" \
    description="spAligners - Container with SpaceRanger"

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


###############################################################################
#                            The Space Ranger link                            #
#       https://www.10xgenomics.com/support/software/space-ranger/downloads   #
###############################################################################

# Space Ranger 3.0.1 (May 31, 2024)

# Visium Spatial Software Suite
# Self-contained, relocatable tar file. Does not require centralized installation.
# Contains binaries pre-compiled for CentOS/RedHat 7.0 and Ubuntu 14.04.
# Runs on Linux systems that meets the minimum compute requirements.


ARG SPACERANGER_VERSION='3.0.1'
ARG SPACERANGER_URL="https://cf.10xgenomics.com/releases/spatial-exp/spaceranger-3.0.1.tar.gz?Expires=1721266908&Key-Pair-Id=APKAI7S6A5RYOXBWRPDA&Signature=GHr5MHRbmGJxOwMYK03u1GfD5sLSSdP~yvzQxvNHzmDa8DDOGNWxigxakdhrP3yRNG03ZgbzH-Ql-HgLuxC-6ylD68RKTed2fQSL-UuzzVRwWvEiZ-Fxu3rLEf8tscVK5uOUfcXlPWYAVSB2h1eUS38EFhgyMWBiGPFdBYY1-LXj~wuKMu9r4LFLVNjNKpqtRmlr93-3wE7d4uJZUbRa25Rr~6oIzaXJx8H860YSmss7cBaOUXoSmVCFGgu~~kJe22CmW~rKSDAXLd5kne8fbOrha80ZO-Vf4jJTc5Uh5zAscNjvRsMQIH4HyfbNcClmzzEoyA3FMrt~egzfPwUzIQ__"

ENV PATH=/opt/spaceranger-${SPACERANGER_VERSION}:$PATH

# Install FastQC
# RUN --mount=type=cache,target=/var/cache/apt apt-get update && \
#    apt-get install -y fastqc

# Install MultiQC
# RUN --mount=type=cache,target=/root/.cache/pip pip3 install multiqc

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# CellRanger binaries
RUN wget ${SPACERANGER_URL} -O spaceranger-${SPACERANGER_VERSION}.tar.gz
RUN tar -zxvf spaceranger-${SPACERANGER_VERSION}.tar.gz \
    && rm -rf spaceranger-${SPACERANGER_VERSION}.tar.gz

CMD  ["spaceranger"]
