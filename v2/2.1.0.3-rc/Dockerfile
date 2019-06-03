## Dockerfile for a haskell environment
FROM       debian:stretch-20180312

ENV STACK_VERSION 2.1.0.3

## ensure locale is set during build
ENV LANG            C.UTF-8

RUN apt-get update && \
    apt-get install -y procps curl ca-certificates g++ libgmp-dev libncurses-dev make xz-utils git zlib1g-dev && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz.sha256 -o stack.tar.gz.sha256 && \
# verify download checksum (asc files for 2.1.0.1 were not published, so no gpg verification is possible)
    echo `cat stack.tar.gz.sha256` stack.tar.gz | sha256sum -c && \
# we're done with curl so remove it
    apt-get purge -y --auto-remove curl && \
# extract stack and install it
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
# cleanup after ourselves and trim the image some
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz.sha256 /stack.tar.gz /usr/share/doc/* /usr/share/man/* /usr/local/share/doc/* /usr/local/share/man/* && \
    apt-get clean

ENV PATH /root/.local/bin:$PATH
ENV STACK_ROOT=/stack-root

CMD ["stack"]
