#!/bin/bash

keepup=$HOME/keepup

mkdir -p $keepup/downloads
keepup $HOME/downloaded-configs/servers/plugin-versions.conf\
  downloaded-plugins plugins --json-path=mineinabyss.servers.${SERVER_NAME}
#--token=${KEEPUP_PRIVATE_TOKEN}
