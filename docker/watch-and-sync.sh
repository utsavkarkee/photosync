#!/bin/sh

WATCH_DIR="/source/uploads"
REMOTE="idrivee2:immich-photo"
LOCKFILE="/tmp/rclone-sync.lock"

# Function to perform sync
do_sync() {
    # Check if another sync is running
    if [ -e "$LOCKFILE" ]; then
        echo "Another sync is running, skipping..."
        return
    fi

    # Create lock file
    touch "$LOCKFILE"

    echo "Starting sync at $(date)"
    rclone sync "$WATCH_DIR" "$REMOTE" \
        --progress \
        --transfers 4 \
        --checkers 8 \
        --s3-chunk-size 32M \
        --retries 3 \
        --log-level INFO

    # Remove lock file
    rm -f "$LOCKFILE"
    echo "Sync completed at $(date)"
}

# Initial sync
do_sync

# Watch for changes
inotifywait -m -r -e create,modify,delete,move "$WATCH_DIR" | while read path action file; do
    echo "Change detected: $action $path$file"
    sleep 5
    do_sync
done
