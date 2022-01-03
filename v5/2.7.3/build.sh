#!/bin/sh

set -e

TAG_ROOT=flipstone/stack:v5-2.7.3
ARM_TAG="$TAG_ROOT"-arm64
AMD_TAG="$TAG_ROOT"-amd64

echo $ARM_TAG
echo $AMD_TAG

COMMAND=$1

case $COMMAND in
  amd64)
    docker build --tag $AMD_TAG --file Dockerfile.amd64 .
    docker push $AMD_TAG
    ;;
  arm64)
    docker build --tag $ARM_TAG --file Dockerfile.arm64 .
    docker push $ARM_TAG
    ;;
  manifest)
    echo "Both $AMD_TAG and $ARM_TAG must be pushed to Docker Hub BEFORE running this step."
    echo "Press enter to continue"
    read
    docker manifest create $TAG_ROOT --amend $AMD_TAG --amend $ARM_TAG
    docker manifest push $TAG_ROOT
    ;;
  *)
    echo "usage: ./build.sh amd64|arm64"
    exit 1
esac;

