FROM --platform=linux/x86_64 oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scCommons - Container with several packages associated with reports generation and data analysis"

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
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

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

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

# Setting repository URL
ARG R_REPO='http://cran.us.r-project.org'

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${WEB_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_BIOC_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"

#RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${SEURAT}, 'seurat5', repos = \"${R_REPO}\", quiet = TRUE)"
#RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${DEV_DEPS}, repos = \"${R_REPO}\")"

# Install Seurat Wrappers
#RUN wget https://api.github.com/repos/oandrefonseca/seurat-wrappers/tarball/seurat5 -O /opt/seurat-wrappers.tar.gz
#RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_local('/opt/seurat-wrappers.tar.gz')"

CMD ["R"]
