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

FROM azul/zulu-openjdk-alpine:25-jre as minecraft
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"

RUN apk add --no-cache wget unzip jq attr file rclone util-linux git gcompat

# Copy extra binaries
COPY --from=helper /binaries /usr/local/bin

ENV\
    SERVER_NAME=dev\
    UPDATE_DATA_OWNER=true\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    CONFIGS_PULL=true\
    CONFIGS_BRANCH=prod\
    HOME=/data\
    LC_ALL=C.UTF-8\
    UID=1000\
    GID=1000\
    VERSION=latest\
    EULA=false\
    JVM_REMOTE_DEBUG=false\
    MEMORY=2G\
    JVM_XX_OPTS=""\
    JVM_OPTS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"\
    SERVER_JAR=server.jar\
    EXTRA_ARGS=""

# Copy over scripts
COPY scripts /scripts

RUN chmod +x -R /scripts && \
    mkdir /configs && \
    ln -sf /scripts/pull_config_repos /scripts/ansible
# (mineinabyss plugin hard-codes /scripts/ansible currently, remove this line when it's updated)

WORKDIR $HOME
ENTRYPOINT ["/scripts/entrypoint"]
