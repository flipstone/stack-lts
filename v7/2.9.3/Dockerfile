FROM debian:unstable-20230109-slim
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT

RUN apt-get update && apt-get install -y curl build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 zlib1g-dev

ADD install_ghcup.sh /install_ghcup.sh
RUN /bin/sh /install_ghcup.sh

RUN ghcup install stack 2.9.3

RUN echo 'export PATH=/root/.local/bin:/root/.ghcup/bin:$PATH' >> /root/.bashrc

ENTRYPOINT ["/bin/bash", "-l", "-c"]
CMD ["stack"]
