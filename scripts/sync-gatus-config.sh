#!/bin/bash

REPO="git@github.com:ClubCedille/k8s-cloud.git"
FILE="config.yaml"
LOCAL_PATH="/etc/gatus/config.yaml"
TMP_PATH="/tmp/config.yaml"
CONTAINER_NAME="gatus"


git archive --remote="$REPO" main "$FILE" | tar -xO > "$TMP_PATH" 2>/dev/null


if [ -s "$TMP_PATH" ]; then
    if [ ! -f "$LOCAL_PATH" ] || ! cmp -s "$TMP_PATH" "$LOCAL_PATH"; then
        echo "Updating $LOCAL_PATH"
        cp "$TMP_PATH" "$LOCAL_PATH"
        
  
        chown 65534:65534 "$LOCAL_PATH"
        
        docker kill -s SIGHUP "$CONTAINER_NAME"
    else
        echo "No changes detected in $FILE"
    fi
else
    echo "Failed to fetch $FILE from the repository."
fi