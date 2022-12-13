# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM marctv/minecraft-papermc-server:1.19
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"

RUN apt-get update -y \
 && apt-get install -y rclone wget unzip

ENV PLUGINS_BRANCH plugin-versions
ENV KEEPUP_PATH local
ENV KEEPUP enabled
ENV PULL_PLUGINS true

ARG KEEPUP_VERSION=1.0.0

WORKDIR /opt/minecraft

RUN wget -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-1.0.0.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip keepup.zip \
    && rclone copy keepup-${KEEPUP_VERSION}/ /usr/local \
    && chmod +x /usr/local/bin/keepup \
    && rm -rf keepup.zip keepup-${KEEPUP_VERSION}

COPY ./entrypoint-mia.sh /opt/minecraft
RUN chmod +x /opt/minecraft/entrypoint-mia.sh

WORKDIR /data

ENTRYPOINT ["/opt/minecraft/entrypoint-mia.sh"]
