FROM aarm64/debian:bullseye-20211220 as fetcher

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates  \
      wget \
      xz-utils && \
    rm -rf /var/lib/apt/lists/*

FROM fetcher as llvm

RUN wget https://github.com/llvm/llvm-project/releases/download/llvmorg-6.0/clang+llvm-6.0-aarch64-linux-gnu.tar.xz && \
    tar -xf clang+llvm-6.0-aarch64-linux-gnu.tar.xz && \
    rm clang+llvm-6.0-aarch64-linux-gnu.tar.xz && \
    mkdir /llvm && \
    cp -R clang+llvm-6.0-aarch64-linux-gnu/* /llvm && \
    rm -r clang+llvm-6.0-aarch64-linux-gnu

FROM fetcher as docker

# Install docker
RUN mkdir /docker && cd /docker && \
    wget https://download.docker.com/linux/static/stable/aarch64/docker-20.10.10.tgz && \
    tar -xzf docker-20.10.10.tgz && \
    wget "https://github.com/docker/compose/releases/download/v2.1.0/docker-compose-$(uname -s)-$(uname -m)" -O docker-compose && \
    chmod +x docker-compose

FROM debian:buster-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      apt-transport-https \
      ca-certificates \
      curl \
      gcc \
      git \
      gnupg \
      netbase \
      libgmp-dev \
      libnuma-dev \
      libpq-dev \
      libssl-dev \
      libtinfo-dev \
      libtinfo5 \
      locales \
      make \
      xz-utils \
      zlib1g-dev && \
    rm -rf /var/lib/apt/lists/*

COPY stack-aarch64-v2.7.3.tar.gz /usr/local/bin

RUN cd /usr/local/bin && \
    tar -xzf stack-aarch64-v2.7.3.tar.gz && \
    rm stack-aarch64-v2.7.3.tar.gz && \
    chmod +x stack

COPY --from=llvm /llvm /usr/local

COPY --from=docker /docker/docker/docker /usr/local/bin

COPY --from=docker /docker/docker-compose /usr/local/bin

# locale
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8
ENV LC_ALL en_US.UTF-8

# directories
RUN mkdir -p /home/app
RUN mkdir -p /root/.local/bin

WORKDIR /home/app

ENV STACK_ROOT=/stack-root
# cmd
CMD ["/bin/sh"]
