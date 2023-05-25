#!/bin/sh
set -e

# run playbook if local.yml file present
if [ -f "/server-config/local.yml" ]; then
  echo "Running ansible-playbook"
  ansible-playbook /server-config/local.yml --extra-vars "server_name=$SERVER_NAME dest=/data"
fi
