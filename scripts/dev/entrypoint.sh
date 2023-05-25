#!/bin/sh

set -e
sleep 1

exec /scripts/keepup-dev
exec /scripts/ansible

exec /start
