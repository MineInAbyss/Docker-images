#!/bin/bash

# If env variable BACKUP_PATHS is set
if [ -n "BACKUP_PATHS" ]; then
  # Get the last restic snapshot date in json format
  latestTime=$(restic snapshots --json --latest 1 | jq -r '.[0]["time"]')

  # Check if it has been more than 30 hours since the last backup
  if [ "$latestTime" = "null" ] || ["$(date -d "$latestTime" +%s)" -lt "$(date -d "30 hours ago" +%s)"]; then
    # Loads any secrets from a file as environment variables
    # Create restic backup
    restic backup ${BACKUP_PATHS}
    # Keeps all snapshots made within last day, daily for the last week, weekly for the last month, monthly for the last year, and yearly for the last 75 years
    restic forget --keep-within 1d --keep-within-daily 7d --keep-within-weekly 1m --keep-within-monthly 1y --keep-within-yearly 75y
  fi
fi
