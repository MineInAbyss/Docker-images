# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM alpine as helper
ARG KEEPUP_VERSION='3.0.0-alpha.1'
RUN wget -nv -q -O keepup.zip https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup-shadow-${KEEPUP_VERSION}.zip  \
    # unzip file inside hocon-to-json.zip into /usr/local \
    && unzip -q keepup.zip \
    && mv keepup-shadow-${KEEPUP_VERSION}/ keepup
# Install YourKit Java Profiler agents
#RUN wget -q https://www.yourkit.com/download/docker/YourKit-JavaProfiler-2023.9-docker.zip -P /tmp/ && \
#  unzip /tmp/YourKit-JavaProfiler-2023.9-docker.zip -d /usr/local && \


FROM itzg/minecraft-server:java21-alpine as minecraft
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"
RUN apk add --no-cache ansible-core rclone wget unzip jq openssh
COPY --from=helper /keepup /usr/local
ENV\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    ANSIBLE=true\
    ANSIBLE_PULL=true\
    ANSIBLE_PULL_BRANCH=master\
    SERVER_NAME=dev\
    HOME=/data\
    ANSIBLE_CONFIG=/server-config/ansible.cfg

# Install ansible collections
COPY config/ansible-requirements.yml /opt/ansible/requirements.yml
RUN ansible-galaxy collection install -r /opt/ansible/requirements.yml -p /opt/ansible/collections \
    && rm /opt/ansible/requirements.yml

# Copy over scripts
COPY scripts/dev /scripts/dev
RUN chmod +x /scripts/dev/*

WORKDIR $HOME
ENTRYPOINT ["/scripts/dev/entrypoint"]


FROM itzg/bungeecord as proxy
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"
RUN apt-get update -y \
 && apt-get install -y rsync rclone wget unzip git pipx python3-venv jq
COPY --from=helper /keepup /usr/local
ENV\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    ANSIBLE=true\
    ANSIBLE_PULL=true\
    ANSIBLE_PULL_BRANCH=master\
    SERVER_NAME=dev\
    HOME=/server\
    ANSIBLE_CONFIG=/server-config/ansible.cfg

# Install ansible & collections
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install ansible-core
COPY config/ansible-requirements.yml /opt/ansible/requirements.yml
RUN ansible-galaxy collection install -r /opt/ansible/requirements.yml -p /opt/ansible/collections \
    && rm /opt/ansible/requirements.yml

# Copy over scripts
COPY scripts/dev /scripts/dev
RUN chmod +x /scripts/dev/*

WORKDIR $HOME
RUN cp /usr/bin/run-bungeecord.sh /start
ENTRYPOINT ["/scripts/dev/entrypoint"]
