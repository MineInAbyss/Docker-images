FROM        --platform=$BUILDPLATFORM ghcr.io/pterodactyl/yolks:java_16

RUN         apk add --update --no-cache ansible

COPY        ./../entrypoint.sh /entrypoint.sh
CMD         [ "/bin/ash", "/entrypoint.sh" ]
