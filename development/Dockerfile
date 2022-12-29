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

WORKDIR /opt/minecraft

RUN wget -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-${KEEPUP_VERSION}.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip keepup.zip \
    && rclone copy keepup-${KEEPUP_VERSION}/ /usr/local \
    && chmod +x /usr/local/bin/keepup \

COPY ./entrypoint-mia.sh /opt/minecraft
RUN chmod +x /opt/minecraft/entrypoint-mia.sh

WORKDIR /data

ENTRYPOINT ["/opt/minecraft/entrypoint-mia.sh"]
