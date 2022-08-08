# ----------------------------------
# Pterodactyl Core Dockerfile
# Environment: Java
# Minimum Panel Version: 0.6.0
# ----------------------------------
FROM --platform=$BUILDPLATFORM adoptopenjdk/openjdk11:alpine-jre

MAINTAINER DevScyu, <scyu@scyu.dev>

RUN apk add --no-cache --update curl ca-certificates openssl git tar bash sqlite fontconfig ansible rsync \
    && adduser --disabled-password --home /home/container container

USER container
ENV  USER=container HOME=/home/container

WORKDIR /home/container

COPY ./../entrypoint.sh /entrypoint.sh

CMD ["/bin/bash", "/entrypoint.sh"]
