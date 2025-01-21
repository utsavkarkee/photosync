#!/bin/sh
set -e

# Backup uploads
sync /source/uploads idrivee2:immich-photo

# Backup postgres data
rclone sync /source/postgres idrivee2:immich-db

# Log the backup completion
echo "Backup completed at $(date)"
