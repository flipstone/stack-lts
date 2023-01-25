FROM debian:unstable-20230109-slim
ARG TARGETPLATFORM
ARG TARGETARCH
ARG TARGETVARIANT

RUN echo "echo TARGETPLATFORM: $TARGETPLATFORM"
RUN echo "echo TARGETARCH: $TARGETARCH"
RUN echo "echo TARGETVARIANT: $TARGETVARIANT"
RUN apt-get update && apt-get install -y curl build-essential curl libffi-dev libffi8 libgmp-dev libgmp10 libncurses-dev libncurses5 libtinfo5 zlib1g-dev

ADD install_ghcup.sh /install_ghcup.sh
RUN /bin/sh /install_ghcup.sh

RUN ghcup install stack 2.9.3

CMD ["/root/.ghcup/bin/stack"]
