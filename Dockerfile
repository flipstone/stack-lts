## Dockerfile for a haskell environment
FROM       debian:stretch

ARG STACK_VERSION
ARG LTS_VERSION

## ensure locale is set during build
ENV LANG            C.UTF-8

RUN apt-get update && \
    apt-get install -y curl gnupg2 ca-certificates g++ libgmp-dev libncurses-dev make xz-utils git zlib1g-dev && \
# fetch stack and the gpg sig
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz.asc -o stack.tar.gz.asc && \
# setup gpg and get keys
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys C5705533DA4F78D8664B5DC0575159689BEFB442 && \
# verify stack signature
    gpg --batch --verify stack.tar.gz.asc stack.tar.gz && \
# we're done with curl and gnupg2 so purge them
    apt-get purge -y --auto-remove curl gnupg2 && \
# extract stack and install it
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
# cleanup after ourselves and trim the image some
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz.asc /stack.tar.gz /usr/share/doc/* /usr/share/man/* /usr/local/share/doc/* /usr/local/share/man/* && \
    apt-get clean

ENV PATH /root/.local/bin:$PATH
ENV STACK_ROOT=/stack-root
RUN stack --resolver lts-$LTS_VERSION setup && \
    stack --resolver lts-$LTS_VERSION install stylish-haskell hlint intero

## run ghci by default unless a command is specified
CMD ["stack", "ghci"]
