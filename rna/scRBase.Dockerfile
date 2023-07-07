FROM --platform=linux/x86_64 r-base:4.3.0

LABEL maintainer="Andre Fonseca" \
    description="scRBase - Container with several packages associated with reports generation and data analysis"

# Timezone settings
ENV TZ=US/Central
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    echo $TZ > /etc/timezone

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN --mount=type=cache,target=/var/cache/apt \
    apt-get update && \
    apt-get install -y procps \
    ca-certificates \
    wget \
    curl \
    bzip2 \
    libglib2.0-0 \
    libxext6 \
    libsm6 \
    libxrender1 \
    software-properties-common \
    pandoc \
    quarto \
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

# Downloading Quarto
RUN wget https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.433/quarto-1.3.433-linux-amd64.tar.gz -O /opt/quarto-1.3.433-linux-amd64.tar.gz
RUN tar -C /opt -xvzf quarto-1.3.433-linux-amd64.tar.gz
RUN ln -s /opt/quarto-1.3.433/bin/quarto /bin/quarto
RUN quarto check

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Install fundamental R packages
ARG R_DEPS="c(\
    'tidyverse', \
    'devtools', \
    'rmarkdown', \
    'patchwork', \
    'BiocManager', \
    'remotes' \
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
    'terra', \ 
    'ggrastr' \
    )"

# Setting repository URL
ARG R_REPO='http://cran.us.r-project.org'

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${WEB_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_BIOC_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"

# Install Seurat Wrappers
RUN wget https://github.com/satijalab/seurat/archive/refs/heads/seurat5.zip -O /opt/seurat-v5.zip
RUN wget https://github.com/satijalab/seurat-data/archive/refs/heads/seurat5.zip -O /opt/seurat-data.zip
RUN wget https://github.com/satijalab/seurat-wrappers/archive/refs/heads/seurat5.zip -O /opt/seurat-wrappers.zip

RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_local('/opt/seurat-v5.zip')"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_local('/opt/seurat-data.zip')"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_local('/opt/seurat-wrappers.zip')"

RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "devtools::install_github(${DEV_DEPS}, repos = \"${R_REPO}\")"

CMD ["R"]
