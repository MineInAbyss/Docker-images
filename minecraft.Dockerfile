# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM itzg/minecraft-server:java17-alpine
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"

RUN apk add --no-cache ansible-core rclone wget unzip jq openssh

ARG KEEPUP_VERSION=2.0.2

ENV\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    ANSIBLE=true\
    ANSIBLE_PULL=true\
    ANSIBLE_PULL_BRANCH=master\
    SERVER_NAME=dev\
    HOME=/data\
    ANSIBLE_CONFIG=/server-config/ansible.cfg

WORKDIR /opt/minecraft

# Install YourKit Java Profiler agents
#RUN wget -q https://www.yourkit.com/download/docker/YourKit-JavaProfiler-2023.9-docker.zip -P /tmp/ && \
#  unzip /tmp/YourKit-JavaProfiler-2023.9-docker.zip -d /usr/local && \
#  rm /tmp/YourKit-JavaProfiler-2023.9-docker.zip

# Install keepup
RUN wget -nv -q -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-shadow-${KEEPUP_VERSION}.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip -q keepup.zip \
    && rclone copy keepup-shadow-${KEEPUP_VERSION}/ /usr/local \
    && chmod +x /usr/local/bin/keepup \
    && rm -rf keepup.zip keepup-shadow-${KEEPUP_VERSION}

# Install ansible collections
COPY config/ansible-requirements.yml /opt/ansible/requirements.yml

RUN ansible-galaxy collection install -r /opt/ansible/requirements.yml -p /opt/ansible/collections \
    && rm /opt/ansible/requirements.yml

# Copy over scripts
COPY scripts/dev /scripts/dev
RUN chmod +x /scripts/dev/*

WORKDIR $HOME

ENTRYPOINT ["/scripts/dev/entrypoint"]
