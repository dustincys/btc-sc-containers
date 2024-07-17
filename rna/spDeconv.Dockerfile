FROM --platform=linux/x86_64 continuumio/miniconda3

LABEL maintainer="Yanshuo Chu" \
    description="spDeconv - Container with spatial deconvolution"

RUN git clone https://github.com/digitalcytometry/cytospace
RUN cd cytospace && \
    conda config --set ssl_verify false
RUN conda env create -f /cytospace/environment.yml
RUN conda activate cytospace_v1.1.0
RUN pip install .
RUN pip install lapjv==1.3.14

CMD ["cytospace"]
