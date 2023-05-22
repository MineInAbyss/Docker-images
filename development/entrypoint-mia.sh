#!/bin/sh

set -e
sleep 1

keepup=/data/keepup
keepupMia=keepup/mineinabyss.conf
keepupDownloads=$keepup/downloads
keepupLocal=$keepup/local.conf
paperPlugins=/data/plugins

mkdir -p $keepup
mkdir -p $keepupDownloads
mkdir -p $paperPlugins

if [ "$KEEPUP" = "enabled" ]; then
  # Get the keepup config file
  if [ -f "/server-config/servers/plugin-versions.conf" ]; then
    echo "Copying plugin-versions.conf to $keepupLocal, not pulling from github"
    cp /server-config/servers/plugin-versions.conf $keepupMia
  elif [ "$PULL_PLUGINS" = "true" ]; then
    echo "Pulling plugins from $PLUGINS_BRANCH"
    wget https://raw.githubusercontent.com/MineInAbyss/server-config/$PLUGINS_BRANCH/servers/minecraft/plugin-versions.conf -O $keepupMia
  else
    echo "PULL_PLUGINS is false, not pulling updates"
  fi

  # If $keepupLocal doesn't exist, create it with some default contents
  if [ ! -f $keepupLocal ]; then
    echo "Creating default local keepup file"
    echo "local: \${paper.core} \${paper.utility.dev-tools} {}" >$keepupLocal
  fi

  echo "Running keepup!"
  # Combines two conf files and runs keepup on the result
  cat $keepupMia $keepupLocal 2>/dev/null | keepup - $keepupDownloads $paperPlugins --json-path=$KEEPUP_PATH
fi

# run playbook if local.yml file present
if [ -f "/server-config/local.yml" ]; then
  echo "Running ansible-playbook"
  ansible-playbook /server-config/local.yml --extra-vars "server_name=$SERVER_NAME dest=/data"
fi

exec /start
