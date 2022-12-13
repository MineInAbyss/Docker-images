#!/bin/ash
#
# Copyright (c) 2021 Matthew Penner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# Default the TZ environment variable to UTC.
TZ=${TZ:-UTC}
export TZ

# Set environment variable that holds the Internal Docker IP
INTERNAL_IP=$(ip route get 1 | awk '{print $NF;exit}')
export INTERNAL_IP

# Switch to the container's working directory
cd /home/container || exit 1

# Print Java version
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0mjava -version\n"
java -version

definedBranch=$(cat config-branch 2>/dev/null)

# wget and run update-configs.sh from our desired branch (if we ever update it, we wget now instead of having to run ansible-pull twice)
wget -O - "https://raw.githubusercontent.com/MineInAbyss/server-config/${definedBranch:=master}/update-configs.sh" | sh

# If file named secrets-backup exists
if [ -f "secrets-backup" ]; then
  # Get the last restic snapshot date in json format
  latestTime=$(restic snapshots --json --latest 1 | jq -r '.[0]["time"]')

  # Check if it has been more than 30 hours since the last backup
  if [ "$latestTime" = "null" ] || ["$(date -d "$latestTime" +%s)" -lt "$(date -d "30 hours ago" +%s)"]; then
    # Loads any secrets from a file as environment variables
    source /home/container/secrets-backup

    # Create restic backup
    restic backup ${BACKUP_PATHS}

    # Keeps all snapshots made within last day, daily for the last week, weekly for the last month, monthly for the last year, and yearly for the last 75 years
    restic forget --keep-within 1d --keep-within-daily 7d --keep-within-weekly 1m --keep-within-monthly 1y --keep-within-yearly 75y
  fi
fi

# Convert all of the "{{VARIABLE}}" parts of the command into the expected shell
# variable format of "${VARIABLE}" before evaluating the string and automatically
# replacing the values.
PARSED=$(echo "${STARTUP}" | sed -e 's/{{/${/g' -e 's/}}/}/g' | eval echo "$(cat -)")

# Display the command we're running in the output, and then execute it with the env
# from the container itself.
printf "\033[1m\033[33mcontainer@pterodactyl~ \033[0m%s\n" "$PARSED"
# shellcheck disable=SC2086
exec env ${PARSED}