# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM openjdk:17-slim
LABEL org.opencontainers.image.authors="DevScyu <scyu@scyu.dev>, Offz <offz@mineinabyss.com>"

RUN apt-get update -y \
 && apt-get install -y curl ca-certificates openssl git tar sqlite3 fontconfig tzdata iproute2 ansible rclone wget restic jq unzip rsync \
 && useradd -d /home/container -m container

ARG KEEPUP_VERSION=1.1.0

RUN wget -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-${KEEPUP_VERSION}.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip keepup.zip \
    && rclone copy keepup-${KEEPUP_VERSION}/ /usr/local \
    && chmod +x /usr/local/bin/keepup \
    && rm -rf keepup.zip keepup-${KEEPUP_VERSION}

USER container
ENV  USER=container HOME=/home/container CONFIG_PULL_BRANCH=master

WORKDIR $HOME

COPY scripts/prod/* /scripts/prod/

CMD ["/bin/bash", "/scripts/prod/entrypoint"]
