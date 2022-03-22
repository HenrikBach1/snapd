# !/bin/bash
# postStartCommand.bat:

export ENV=export
export RUN=

# HB1: It seems that build.args doesn't pass to Dockerfile build from .devcontainer:
$ENV remoteUser=vscode
$ENV PACKAGER_NAME="Henrik Bach"
$ENV PACKAGER_EMAIL="bach.henrik@gmail.com"

$ENV VARIANT="3.15"
$ENV DockerfileContext="/home/sad/projects/snapd/snapd-github-public-master-live-devcontainer-alpine"
$ENV SNAPD_ABUILD_DIR=${DockerfileContext}/./packaging/alpine-${VARIANT}/snapd

# # To build toAPK:
# $ENV LUA_ROCKS=luarocks-5.3
# $ENV TOAPK_DIR="/data/alpine/toapk"
# # HB1: TODO: RUN GIT_CLONE(https://gitlab.com/Durrendal/toAPK.git, ${TOAPK_DIR})
# RUN doas mkdir -p ${TOAPK_DIR} \
#     && doas git clone https://gitlab.com/Durrendal/toAPK.git ${TOAPK_DIR} \
#     && doas chgrp abuild -R ${TOAPK_DIR} \
#     && doas chmod g+w -R ${TOAPK_DIR} \
#     && sudo ln -s ${TOAPK_DIR}/src/toAPK.fnl /usr/bin <------------------ # # HB1: TODO: Fails: https://gitlab.com/Durrendal/toAPK/-/issues/4
# # HB1: TODO: https://gitlab.com/Durrendal/toAPK/-/issues/4#note_846955420

#     # Tag : Commit
#     # v1.0: 621b1479
#     # && git checkout 621b1479 \
#     #
#     # && $LUA_ROCKS install luasec --local \
#     # EOL
# RUN cd ${TOAPK_DIR} \
#     && $LUA_ROCKS install luasocket --local
#     && make compile-bin \
#     && doas make install-bin \
#     && make compile-lua <------------------ Fails: https://gitlab.com/Durrendal/toAPK/-/issues/4
# #     && doas make install-lua
# #     && make test-all

# # To build aports: Is this necessary?:
# $ENV APORTS_DIR="/data/alpine/aports"
# # HB1: TODO: RUN GIT_CLONE(https://gitlab.alpinelinux.org/alpine/aports, ${APORTS_DIR})
# RUN doas mkdir -p ${APORTS_DIR} \
#     && doas git clone https://gitlab.alpinelinux.org/alpine/aports ${APORTS_DIR} \
#     && doas chgrp abuild -R ${APORTS_DIR} \
#     && doas chmod g+w -R ${APORTS_DIR}

RUN git config --global user.name "${PACKAGER_NAME}"
RUN git config --global user.email "${PACKAGER_EMAIL}"

RUN doas sed -i s/#PACKAGER=/PACKAGER=/g /etc/abuild.conf
RUN doas sed -i s/#MAINTAINER=/MAINTAINER=/g /etc/abuild.conf
RUN doas sed -i 's/your@email.address/'"${PACKAGER_EMAIL}"'/g' /etc/abuild.conf
RUN doas sed -i 's/Your\ Name/'"${PACKAGER_NAME}"'/g' /etc/abuild.conf

RUN mkdir -p /home/vscode/.abuild \
    && touch /home/vscode/.abuild/abuild.conf \
    && cp /etc/abuild.conf /home/vscode/.abuild

RUN abuild-keygen -ain

WORKDIR ${SNAPD_ABUILD_DIR}
RUN cd ${SNAPD_ABUILD_DIR} \
    && find .. -exec readlink -f {} \; \
    && abuild checksum && abuild -r
