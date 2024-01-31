# Use mambaorg/micromamba as the base image
FROM oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scTCR - Collection of methods related to scTCR analysis and scRNA/TCR integration"

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

RUN --mount=type=cache,target=/var/cache/apt \
    apt-get install -y g++

# Install required R packages
ARG R_DEPS="c(\
    'immunarch',\
    'BiocManager',\
    'remotes'\
    )"

ARG R_BIOC_DEPS="c(\
    'scRepertoire'\
    )"

ARG DEV_DEPS="c(\
    'Japrin/STARTRAC'\
    )"

# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Setting repository URL
ARG R_REPO='http://cran.us.r-project.org'

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "BiocManager::install(${R_BIOC_DEPS})"
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "remotes::install_github(${DEV_DEPS})"

# Installing Conga requirements
RUN micromamba install -y seaborn scikit-learn statsmodels numba pytables
RUN micromamba install -y -c conda-forge python-igraph leidenalg louvain notebook
RUN micromamba install -y -c intel tbb # optional

# Cloning conga package
RUN git clone https://github.com/phbradley/conga.git
RUN cd conga/tcrdist_cpp && make
RUN cd /opt && pip install -e ./conga

# Cloning TCRi package
RUN git clone https://github.com/nceglia/tcri.git
RUN pip install gseapy statannot mpltern
RUN cd TCRi && python3 setup.py install

# Cloning TESSA pipeline
RUN git clone https://github.com/jcao89757/TESSA.git

# Cloning scib pipeline
RUN git clone https://github.com/theislab/scib-pipeline.git
