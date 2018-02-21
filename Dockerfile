## Dockerfile for a haskell environment
FROM       debian:stretch

ARG GHC_VERSION
ARG STACK_VERSION
ARG CABAL_VERSION
ARG HAPPY_VERSION
ARG ALEX_VERSION
ARG LTS_VERSION

## ensure locale is set during build
ENV LANG            C.UTF-8

RUN apt-get update && \
    apt-get install -y gnupg2 procps && \
    echo 'deb http://ppa.launchpad.net/hvr/ghc/ubuntu xenial main' > /etc/apt/sources.list.d/ghc.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F6F88286 && \
    apt-get update && \
    apt-get install -y --no-install-recommends cabal-install-$CABAL_VERSION ghc-$GHC_VERSION happy-$HAPPY_VERSION alex-$ALEX_VERSION \
            zlib1g-dev libtinfo-dev libsqlite3-0 libsqlite3-dev ca-certificates g++ git curl && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz -o stack.tar.gz && \
    curl -fSL https://github.com/commercialhaskell/stack/releases/download/v$STACK_VERSION/stack-$STACK_VERSION-linux-x86_64-static.tar.gz.asc -o stack.tar.gz.asc && \
    apt-get purge -y --auto-remove curl && \
    apt-get clean && \
    export GNUPGHOME="$(mktemp -d)" && \
    gpg --keyserver ipv4.pool.sks-keyservers.net --recv-keys C5705533DA4F78D8664B5DC0575159689BEFB442 && \
    gpg --batch --verify stack.tar.gz.asc stack.tar.gz && \
    tar -xf stack.tar.gz -C /usr/local/bin --strip-components=1 && \
    /usr/local/bin/stack config set system-ghc --global true && \
    rm -rf "$GNUPGHOME" /var/lib/apt/lists/* /stack.tar.gz.asc /stack.tar.gz

ENV PATH /root/.cabal/bin:/root/.local/bin:/opt/cabal/$CABAL_VERSION/bin:/opt/ghc/$GHC_VERSION/bin:/opt/happy/$HAPPY_VERSION/bin:/opt/alex/$ALEX_VERSION/bin:$PATH

ENV STACK_ROOT=/stack-root

RUN stack config set system-ghc --global true && \
    stack --resolver lts-$LTS_VERSION install stylish-haskell hlint

VOLUME /stack-root

## run ghci by default unless a command is specified
CMD ["ghci"]
