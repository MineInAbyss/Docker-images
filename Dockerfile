# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM alpine AS helper
ARG KEEPUP_VERSION='3.1.1'
RUN wget -nv -q -O keepup https://github.com/MineInAbyss/Keepup/releases/download/v${KEEPUP_VERSION}/keepup \
    && chmod +x keepup
# Install YourKit Java Profiler agents
#RUN wget -q https://www.yourkit.com/download/docker/YourKit-JavaProfiler-2023.9-docker.zip -P /tmp/ && \
#  unzip /tmp/YourKit-JavaProfiler-2023.9-docker.zip -d /usr/local && \

FROM container-registry.oracle.com/graalvm/jdk:21-ol9 AS minecraft
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"
#RUN dnf install -y ansible-core rclone wget unzip jq openssh attr
RUN microdnf install -y oracle-epel-release-el9 && \
    microdnf install -y git pipx rclone wget unzip jq openssh attr file

COPY --from=helper /keepup /usr/local/bin
ENV\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    ANSIBLE=true\
    ANSIBLE_PULL=true\
    ANSIBLE_PULL_BRANCH=prod\
    SERVER_NAME=dev\
    HOME=/data\
    ANSIBLE_CONFIG=/server-config/ansible.cfg\
    LC_ALL=C.UTF-8\
    UID=1000\
    GID=1000\
    CUSTOM_SERVER=server.jar

# Install ansible collections
COPY config/ansible-requirements.yml /opt/ansible/requirements.yml
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install ansible-core
RUN ansible-galaxy collection install -r /opt/ansible/requirements.yml -p /opt/ansible/collections \
    && rm /opt/ansible/requirements.yml

# Copy over scripts
COPY scripts /scripts
RUN chmod +x /scripts/*

RUN groupadd --gid 1000 minecraft && \
    useradd --system --shell /bin/false --uid 1000 -g minecraft --home /data minecraft

WORKDIR $HOME
ENTRYPOINT ["/scripts/entrypoint"]


FROM itzg/mc-proxy AS proxy
LABEL org.opencontainers.image.authors="Offz <offz@mineinabyss.com>"
RUN apt-get update -y \
 && apt-get install -y rsync rclone wget unzip git pipx python3-venv jq file
COPY --from=helper /keepup /usr/local/bin
ENV\
    KEEPUP=true\
    KEEPUP_ALLOW_OVERRIDES=true\
    ANSIBLE=true\
    ANSIBLE_PULL=true\
    ANSIBLE_PULL_BRANCH=prod\
    SERVER_NAME=dev\
    HOME=/server\
    TYPE=velocity\
    ANSIBLE_CONFIG=/server-config/ansible.cfg\
    UID=1000\
    GID=1000

# Install ansible & collections
RUN PIPX_HOME=/opt/pipx PIPX_BIN_DIR=/usr/local/bin pipx install ansible-core
COPY config/ansible-requirements.yml /opt/ansible/requirements.yml
RUN ansible-galaxy collection install -r /opt/ansible/requirements.yml -p /opt/ansible/collections \
    && rm /opt/ansible/requirements.yml

# Copy over scripts
COPY scripts /scripts
RUN chmod +x /scripts/*

WORKDIR $HOME

# Rename bungeecord user to minecraft for consistency
RUN usermod --login minecraft bungeecord && groupmod --new-name minecraft bungeecord
# Set base permissions for when no volume is mounted
RUN chown -R minecraft:minecraft $HOME && mkdir -p /server-config && chown -R minecraft:minecraft /server-config

RUN cp /usr/bin/run-bungeecord.sh /start
ENTRYPOINT ["/scripts/entrypoint"]
