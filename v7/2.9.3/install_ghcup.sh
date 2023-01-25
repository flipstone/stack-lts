#!/bin/sh

if [ "$TARGETPLATFORM" = "linux/arm64" ]; then
  URL="https://downloads.haskell.org/~ghcup/0.1.19.0/aarch64-linux-ghcup-0.1.19.0"
elif [ "$TARGETPLATFORM" = "linux/amd64" ]; then
  URL="https://downloads.haskell.org/~ghcup/0.1.19.0/x86_64-linux-ghcup-0.1.19.0"
else
  echo "Unsupported or unspecified platform $TARGETPLATFORM"
  echo "Assuming x86_64"
  URL="https://downloads.haskell.org/~ghcup/0.1.19.0/x86_64-linux-ghcup-0.1.19.0"
fi;

echo $URL
curl -o /usr/bin/ghcup $URL
chmod +x /usr/bin/ghcup
