# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM itzg/minecraft-server:java17-jdk
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"

RUN apt-get update -y \
 && apt-get install -y rclone wget unzip ansible

ARG KEEPUP_VERSION=1.1.0

ENV PLUGINS_BRANCH=plugin-versions KEEPUP_PATH=local KEEPUP=enabled PULL_PLUGINS=true SERVER_NAME=dev HOME=/data

WORKDIR /opt/minecraft

RUN wget -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-${KEEPUP_VERSION}.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip keepup.zip \
    && rclone copy keepup-${KEEPUP_VERSION}/ /usr/local \
    && chmod +x /usr/local/bin/keepup \
    && rm -rf keepup.zip keepup-${KEEPUP_VERSION}

COPY scripts/dev /scripts/dev
RUN chmod +x /scripts/dev/*

WORKDIR $HOME

ENTRYPOINT ["/scripts/dev/entrypoint"]
