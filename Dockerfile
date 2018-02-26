## Dockerfile for a haskell environment
FROM       debian:stretch

ARG GHC_VERSION
ARG STACK_VERSION
ARG LTS_VERSION

## ensure locale is set during build
ENV LANG            C.UTF-8

RUN apt-get update && \
    apt-get install -y curl ca-certificates clang make libgmp-dev gnupg2 xz-utils && \
# fetch ghc and stack, along with the gpg sigs
    curl -fSL https://downloads.haskell.org/~ghc/$GHC_VERSION/ghc-$GHC_VERSION-x86_64-deb8-linux.tar.xz -o ghc.tar.xz && \
    curl -fSL https://downloads.haskell.org/~ghc/$GHC_VERSION/ghc-$GHC_VERSION-x86_64-deb8-linux.tar.xz.sig -o ghc.tar.xz.sig && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz.asc -o stack.tar.gz.asc && \
# setup gpg and get keys
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys 97DB64AD && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys C5705533DA4F78D8664B5DC0575159689BEFB442 && \
# verify both ghc and stack signatures
    gpg --batch --verify ghc.tar.xz.sig ghc.tar.xz && \
    gpg --batch --verify stack.tar.gz.asc stack.tar.gz && \
# we're done with curl and gnupg2 so purge them
    apt-get purge -y --auto-remove curl gnupg2 && \
# extract ghc and install it
    mkdir /root/ghc && \
    tar -xf ghc.tar.xz -C /root/ghc --strip-components=1 && \
    cd /root/ghc && \
    ./configure && \
    make install && \
    cd - && \
# extract stack and install it
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
    stack config set system-ghc --global true && \
# cleanup after ourselves and trim the image some
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz.asc /stack.tar.gz /ghc.tar.xz.sig /ghc.tar.xz /root/ghc /usr/share/doc/* /usr/share/man/* /usr/local/share/doc/* /usr/local/share/man/* && \
    apt-get clean

ENV PATH /root/.local/bin:$PATH

ENV STACK_ROOT=/stack-root

RUN stack config set system-ghc --global true && \
    stack --resolver lts-$LTS_VERSION install stylish-haskell hlint intero

VOLUME /stack-root

## run ghci by default unless a command is specified
CMD ["stack", "ghci"]
