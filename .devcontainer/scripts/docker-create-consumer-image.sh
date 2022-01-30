#! /bin/bash

IMAGE_BASE_NAME=vsc-snapd-github-public-master-live-devcontainer-alpine
IMAGE_TAG=latest
IMAGE_REPO_NAME_NEW=${IMAGE_BASE_NAME}:${IMAGE_TAG}
IMAGE_FILTER_UID=${IMAGE_BASE_NAME}'-*-uid:'${IMAGE_TAG}
IMAGE_FILTER=${IMAGE_BASE_NAME}'*'
IMAGE_ID=$(docker images --filter=reference=${IMAGE_FILTER_UID} | grep -iv image | awk '{ print $3 }')

docker tag ${IMAGE_ID} ${IMAGE_REPO_NAME_NEW}
docker images --filter=reference=${IMAGE_FILTER}
