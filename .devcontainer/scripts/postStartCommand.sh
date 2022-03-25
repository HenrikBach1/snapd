# !/bin/bash
# postStartCommand.bat:
set -xv

echo > nohup.out

export ENV=export
export ARG=export
export RUN=
export WORKDIR=cd
export USER=sudo su

# HB1: It seems that build.args doesn't pass to Dockerfile build from .devcontainer:
$ARG remoteUser=vscode
$ARG VARIANT="3.15"
$ARG PROJECTS_DIR=/projects
$ARG DATA_DIR=${PROJECTS_DIR}/data
$ARG CONTEXT_DIR="${PROJECTS_DIR}/snapd/snapd-github-public-master-live-devcontainer-alpine"

$ARG PACKAGER_NAME="Henrik Bach"
$ARG PACKAGER_EMAIL="bach.henrik@gmail.com"

# $FROM mcr.microsoft.com/vscode/devcontainers/base:0-alpine-${VARIANT}

$ENV SNAPD_ABUILD_DIR=${CONTEXT_DIR}/packaging/alpine-${VARIANT}/snapd

###############################################################################
# Switch to remoteUser
###############################################################################

# Following overall: https://wiki.alpinelinux.org/wiki/Creating_an_Alpine_package:

$USER $remoteUser

# HB1: TODO: $RUN MKDIR(/var/cache/distfiles)
$RUN doas mkdir -p /var/cache/distfiles \
    && doas chgrp abuild -R /var/cache/distfiles \
    && doas chmod g+w -R /var/cache/distfiles

$RUN abuild-keygen -ain

# Build toAPK:
$ENV LUA_ROCKS=luarocks-5.3
$ENV TOAPK_DIR="${DATA_DIR}/alpine/toapk"
# HB1: TODO: $RUN GIT_CLONE(https://gitlab.com/Durrendal/toAPK.git, ${TOAPK_DIR}):
$RUN rm -rf ${TOAPK_DIR}
$RUN mkdir -p ${TOAPK_DIR} \
    && git clone https://gitlab.com/Durrendal/toAPK.git ${TOAPK_DIR}
#     && chgrp abuild -R ${TOAPK_DIR} \
#     && chmod g+w -R ${TOAPK_DIR} \
# #     && sudo ln -s ${TOAPK_DIR}/src/toAPK.fnl /usr/bin <------------------ # # HB1: TODO: Fails: https://gitlab.com/Durrendal/toAPK/-/issues/4
# # HB1: TODO: https://gitlab.com/Durrendal/toAPK/-/issues/4#note_846955420

    # Tag : Commit
    # v1.0: 621b1479
    # && git checkout 621b1479 \
    #
    # && $LUA_ROCKS install luasec --local \
    # EOL
# $RUN cd ${TOAPK_DIR} \
#     && $LUA_ROCKS install luasocket --local \
#     && make compile-bin \
#     && doas make install-bin
$RUN cd ${TOAPK_DIR} \
    && $LUA_ROCKS install luasocket --local \
    && make compile-lua \
    && doas make install-lua
# $RUN cd ${TOAPK_DIR} \
# #     && make test-all

# # To build aports: Is this necessary?:
# $ENV APORTS_DIR="${DATA_DIR}/alpine/aports"
# # HB1: TODO: $RUN GIT_CLONE(https://gitlab.alpinelinux.org/alpine/aports, ${APORTS_DIR}):
# $RUN mkdir -p ${APORTS_DIR} \
#     && git clone https://gitlab.alpinelinux.org/alpine/aports ${APORTS_DIR} \
#     && chgrp abuild -R ${APORTS_DIR} \
#     && chmod g+w -R ${APORTS_DIR}

$RUN git config --global user.name "${PACKAGER_NAME}"
$RUN git config --global user.email "${PACKAGER_EMAIL}"

$RUN doas sed -i s/#PACKAGER=/PACKAGER=/g /etc/abuild.conf
$RUN doas sed -i s/#MAINTAINER=/MAINTAINER=/g /etc/abuild.conf
$RUN doas sed -i 's/your@email.address/'"${PACKAGER_EMAIL}"'/g' /etc/abuild.conf
$RUN doas sed -i 's/Your\ Name/'"${PACKAGER_NAME}"'/g' /etc/abuild.conf

$RUN mkdir -p /home/vscode/.abuild \
    && touch /home/vscode/.abuild/abuild.conf \
    && cp /etc/abuild.conf /home/vscode/.abuild

# $WORKDIR ${SNAPD_ABUILD_DIR}
# $RUN cd ${SNAPD_ABUILD_DIR} \
#     && find .. -exec readlink -f {} \; \
#     && script -c 'abuild checksum && abuild -rv'

# sudo rm /postStartCommand.sh

set +xv
