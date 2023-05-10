FROM r-base:4.2.2
LABEL maintainer="Andre Fonseca" \
    description="scBase - The base container to versioning the single-cell R dependencies"

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN apt-get update && \
    apt-get install -y procps \
    software-properties-common \
    pandoc \
    libcurl4-openssl-dev \
    r-cran-curl \
    libssl-dev \
    libxml2-dev \
    libfontconfig1-dev \
    libharfbuzz-dev \
    libfribidi-dev \
    libfreetype6-dev \
    libpng-dev \
    libtiff5-dev \
    libjpeg-dev \
    libhdf5-dev

# Downloading and Install gcc-6
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-6/gcc-6-base_6.4.0-17ubuntu1_amd64.deb -O /opt/gcc-6-base_6.4.0-17ubuntu1_amd64.deb
RUN dpkg -i /opt/gcc-6-base_6.4.0-17ubuntu1_amd64.deb

# Downloading and Install libgfortran3_6
RUN wget http://archive.ubuntu.com/ubuntu/pool/universe/g/gcc-6/libgfortran3_6.4.0-17ubuntu1_amd64.deb -O /opt/libgfortran3_6.4.0-17ubuntu1_amd64.deb
RUN dpkg -i /opt/libgfortran3_6.4.0-17ubuntu1_amd64.deb

# Install fundamental R packages
ARG R_DEPS="c(\
    'tidyverse', \
    'devtools', \
    'rmarkdown', \
    'patchwork', \
    'BiocManager' \
    )"

ARG SEURAT="c(\
    'satijalab/seurat', \
    'satijalab/seurat-data' \
    )"

ARG DEV_DEPS="c(\
    'bnprks/BPCells' \
    )"

ARG WEB_DEPS="c(\
    'shiny', \
    'DT', \
    'kable', \
    'kableExtra', \
    'flexdashboard', \
    'plotly' \
    )"

ARG R_BIOC_DEPS="c(\
    'Biobase', \
    'BiocGenerics', \
    'DelayedArray', \
    'DelayedMatrixStats', \
    'S4Vectors',\
    'SingleCellExperiment', \
    'SummarizedExperiment', \
    'HDF5Array', \ 
    'limma', \
    'lme4', \
    'terra',\ 
    'ggrastr' \
    )"

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${WEB_DEPS}, Ncpus = 8, clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_BIOC_DEPS}, Ncpus = 8, clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${SEURAT}, 'seurat5', quiet = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${DEV_DEPS})"

# Install Seurat Wrappers
RUN wget https://api.github.com/repos/oandrefonseca/seurat-wrappers/tarball/seurat5 -O /opt/seurat-wrappers.tar.gz
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_local('/opt/seurat-wrappers.tar.gz')"

# Installing Mamba
#RUN wget https://github.com/conda-forge/miniforge/releases/latest/download/Mambaforge-Linux-x86_64.sh -O /opt/Mambaforge-Linux-x86_64.sh && \
#    cd /opt/ && \
#    bash Mambaforge-$(uname)-$(uname -m).sh

CMD ["R"]
