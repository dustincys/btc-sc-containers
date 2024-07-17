FROM --platform=linux/x86_64 oandrefonseca/scrbase:main

LABEL maintainer="Yanshuo Chu" \
    description="spRBase - Container with spatial deconvolution R base"

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN --mount=type=cache,target=/var/cache/apt \
apt-get update && \
apt-get install -y jags

# Install required R packages
ARG R_DEPS="c(\
'hdf5r', \
'Matrix', \
)"


# Cleaning apt-get cache
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/*

# Setting repository URL
ARG R_REPO='http://cran.us.r-project.org'

# Caching R-lib on the building process
RUN --mount=type=cache,target=/usr/local/lib/R Rscript -e "install.packages(${R_DEPS}, Ncpus = 8, repos = \"${R_REPO}\", clean = TRUE)"

# Install ps, for Nextflow. https://www.nextflow.io/docs/latest/tracing.html
RUN --mount=type=cache,target=/var/cache/apt \
apt-get update && \
apt-get install -y libcairo2-dev libxt-dev libnlopt-dev

CMD ["R"]
