FROM ubuntu:latest
LABEL maintainer="Andre Fonseca" \
    description="scVariant - Container with scAllele and other variant callings"
# https://bioconductor.org/packages/devel/bioc/vignettes/FLAMES/inst/doc/FLAMES_vignette.html

# Adding Python PPA
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa

# Install basic requirments
RUN apt-get install -y wget \
    build-essential \
    zlib1g-dev \
    libncurses5-dev \
    libgdbm-dev \
    libnss3-dev \
    libssl-dev \
    libreadline-dev \
    libffi-dev

# Timezone settings
ENV TZ=US/Central
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Installing python3.8
RUN apt-get install -y python3.8
RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.8 1

RUN apt-get install -y python3-pip \
    python3.8-distutils

# Installing packages
RUN pip install scAllele
RUN pip install matplotlib

# Installing Rust
RUN wget https://github.com/10XGenomics/vartrix/releases/download/v1.1.22/vartrix_linux -O /usr/bin/vartrix_linux && \
    chmod +x /usr/bin/vartrix_linux

CMD [ "/bin/bash" ]