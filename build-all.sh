#!/usr/bin/env bash
set -e

BASE_IMAGENAME=fduarte42/docker-sphinxsearch
PLATFORMS=linux/amd64,linux/arm64

cd build
VERSIONS="8.0"

for V in $VERSIONS; do
    docker buildx build --platform $PLATFORMS --push --pull --no-cache --build-arg BASE_IMAGENAME=$BASE_IMAGENAME --build-arg PHP_VERSION=$V -f Dockerfile -t $BASE_IMAGENAME:$V .
    docker buildx build --platform $PLATFORMS --push --pull --no-cache --build-arg BASE_IMAGENAME=$BASE_IMAGENAME --build-arg PHP_VERSION=$V -f Dockerfile-debug -t $BASE_IMAGENAME:$V-debug .
done

cd ..
