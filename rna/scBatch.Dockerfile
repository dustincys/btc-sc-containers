# Use mambaorg/micromamba as the base image
FROM oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scBatch - Collection of methods related to batch correction for single-cell analysis"

# Timezone settings
#ENV TZ=US/Central
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
#    echo $TZ > /etc/timezone

# Install required R packages
ARG R_DEPS="c(\
    'harmony',\
    'BiocManager',\
    'remotes'\
    )"

ARG R_BIOC_DEPS="c(\
    'batchelor'\
    )"

ARG DEV_DEPS="c(\
    'theislab/kBET',\
    'vinay-swamy/scPOP'\
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

# Caching Python library
RUN --mount=type=cache,target=/root/.cache pip install scib

# Installing genevector
RUN --mount=type=cache,target=/root/.cache pip install genevector

# Cloning scib pipeline
RUN git clone https://github.com/theislab/scib-pipeline.git
