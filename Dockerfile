# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM alpine AS helper
ARG KEEPUP_VERSION='3.2.0-alpha.5'

RUN mkdir /binaries && \
    wget -nv -q -O /binaries/keepup https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup && \
    chmod +x /binaries/keepup

# Install rclone
RUN ARCH=$(uname -m | sed 's/x86_64/amd64/' | sed 's/aarch64/arm64/') && \
    wget -q https://downloads.rclone.org/rclone-current-linux-${ARCH}.zip -O /tmp/rclone.zip && \
    unzip -q /tmp/rclone.zip -d /tmp && \
    mv /tmp/rclone-*-linux-${ARCH}/rclone /binaries && \
    chmod +x /binaries/rclone

FROM container-registry.oracle.com/graalvm/jdk:24 AS minecraft
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"

RUN microdnf install -y oracle-epel-release-el10 && \
    microdnf install -y git wget unzip jq attr file

# Copy extra binaries
COPY --from=helper /binaries /usr/local/bin

ENV\
    UPDATE_DATA_OWNER=true\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    CONFIGS_PULL=true\
    CONFIGS_BRANCH=prod\
    SERVER_NAME=dev\
    HOME=/data\
    LC_ALL=C.UTF-8\
    UID=1000\
    GID=1000

# Copy over scripts
COPY scripts /scripts
RUN chmod +x /scripts/*

RUN groupadd --gid 1000 minecraft && \
    useradd --system --shell /bin/false --uid 1000 -g minecraft --home /data minecraft

WORKDIR $HOME
ENTRYPOINT ["/scripts/entrypoint"]
