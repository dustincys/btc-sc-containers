FROM --platform=linux/x86_64 oandrefonseca/scagnostic:main

LABEL maintainer="Andre Fonseca" \
    description="scVariant - Container with scAllele and other variant callings"

# Installing packages
RUN pip3 install scAllele
RUN pip3 install matplotlib

# Installing Rust
RUN wget https://github.com/10XGenomics/vartrix/releases/download/v1.1.22/vartrix_linux -O /usr/bin/vartrix_linux && \
    chmod +x /usr/bin/vartrix_linux

CMD [ "/bin/bash" ]