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

        # EOL
RUN apk update \
    && apk upgrade \
    && apk add --no-cache \
        alpine-sdk \
        curl \
        doas \
        fennel \
        git \
        lua5.3-dev \
        luarocks5.3 \
        make \
        nano \
        openssl-dev \
        sed \
        su-exec \
        sudo \
        shadow \
        wget

RUN echo "$remoteUser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
RUN echo "permit nopass keepenv :$remoteUser" | sudo tee -a /etc/doas.conf

###############################################################################
# Switch to remoteUser
###############################################################################

# Following overall: https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package:

USER $remoteUser

ENV SUDO="doas abuild-keygen -a -i"

RUN doas addgroup $remoteUser abuild

RUN git config --global user.name "${PACKAGER_NAME}"
RUN git config --global user.email "${PACKAGER_EMAIL}"

RUN doas sed -i s/#PACKAGER=/PACKAGER=/g /etc/abuild.conf
RUN doas sed -i s/#MAINTAINER=/MAINTAINER=/g /etc/abuild.conf
RUN doas sed -i 's/your@email.address/'"${PACKAGER_EMAIL}"'/g' /etc/abuild.conf
RUN doas sed -i 's/Your\ Name/'"${PACKAGER_NAME}"'/g' /etc/abuild.conf

# HB1: TODO: RUN MKDIR(/var/cache/distfiles)
RUN doas mkdir -p /var/cache/distfiles \
    && doas chgrp abuild -R /var/cache/distfiles \
    && doas chmod g+w -R /var/cache/distfiles

#------------------------------------------------------------------------------

ENV LUA_ROCKS=luarocks-5.3
ENV TOAPK_DIR="/data/alpine/toapk"

# HB1: TODO: RUN GIT_CLONE(https://gitlab.com/Durrendal/toAPK.git, ${TOAPK_DIR})
RUN doas mkdir -p ${TOAPK_DIR} \
    && doas git clone https://gitlab.com/Durrendal/toAPK.git ${TOAPK_DIR} \
    && doas chgrp abuild -R ${TOAPK_DIR} \
    && doas chmod g+w -R ${TOAPK_DIR}

RUN $LUA_ROCKS install luasocket --local
# RUN $LUA_ROCKS install luasec --local

RUN cd ${TOAPK_DIR} \
    && make compile-bin \
    && doas make install-bin \
    && make compile-lua
#     && doas make install-lua

# ENV APORTS_DIR="/data/alpine/aports"
# RUN doas mkdir -p ${APORTS_DIR} \
#     && doas git clone https://gitlab.alpinelinux.org/alpine/aports ${APORTS_DIR}
