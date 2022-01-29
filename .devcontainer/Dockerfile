# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.209.6/containers/alpine/.devcontainer/base.Dockerfile

# [Choice] Alpine version: 3.14, 3.13, 3.12, 3.11
# HB1: It seems that build.args doesn't pass to Dockerfile build: devcontainer build.args not passed to build image to podman/docker?:
ARG VARIANT="3.14"

ARG remoteUser=vscode
ARG PACKAGER_NAME="Henrik Bach"
ARG PACKAGER_EMAIL="bach.henrik@gmail.com"

FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

# HB1: It seems that build.args doesn't pass to Dockerfile build: devcontainer build.args not passed to build image to podman/docker?:
ENV remoteUser=vscode
ENV PACKAGER_NAME="Henrik Bach"
ENV PACKAGER_EMAIL="bach.henrik@gmail.com"

        # nano \
        # EOL
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        alpine-sdk \
        curl \
        doas \
        git \
        make \
        sed \
        su-exec \
        sudo \
        shadow \
        wget

RUN $(mkdir -p /var/cache/distfiles \
    && chmod a+w /var/cache/distfiles)

RUN echo "$remoteUser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

###############################################################################
# Switch to remoteUser
###############################################################################

USER $remoteUser

ENV SUDO="doas abuild-keygen -a -i"
ENV APORTS_DIR="/data/alpine/aports"

# RUN sudo mkdir -p ${APORTS_DIR} && sudo git clone https://gitlab.alpinelinux.org/alpine/aports ${APORTS_DIR}

# RUN sudo chown $remoteUser:$remoteUser -R /workspaces

RUN sudo sed -i s/#PACKAGER=/PACKAGER=/g /etc/abuild.conf
RUN sudo sed -i s/#MAINTAINER=/MAINTAINER=/g /etc/abuild.conf
RUN sudo sed -i 's/your@email.address/'"${PACKAGER_EMAIL}"'/g' /etc/abuild.conf
RUN sudo sed -i 's/Your\ Name/'"${PACKAGER_NAME}"'/g' /etc/abuild.conf

# RUN doas addgroup $remoteUser abuild
# RUN addgroup $remoteUser abuild
RUN sudo usermod -a -G abuild $remoteUser

RUN git config --global user.name "${PACKAGER_NAME}"
RUN git config --global user.email "${PACKAGER_EMAIL}"
