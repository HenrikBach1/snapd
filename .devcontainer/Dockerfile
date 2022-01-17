# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.209.6/containers/alpine/.devcontainer/base.Dockerfile

# [Choice] Alpine version: 3.14, 3.13, 3.12, 3.11
ARG VARIANT="3.14"
FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

        # doas \
        # nano \
        # EOL
RUN apk update \
    && apk add --no-cache \
        alpine-sdk \
        curl \
        git \
        make \
        sed \
        wget \
        # EOL
