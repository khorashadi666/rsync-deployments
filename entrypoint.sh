#!/bin/sh

set -eu

# Set deploy key
SSH_PATH="$HOME/.ssh"
mkdir -p "$SSH_PATH"
echo "$SSH_PRIVATE_KEY" > "$SSH_PATH/deploy_key"
chmod 600 "$SSH_PATH/deploy_key"

# Variables.
SSH_CMD_ARGS="${SSH_CMD_ARGS:--o StrictHostKeyChecking=no}"
ARGS="${ARGS:--avzr}"
SOURCE="${SOURCE:-/}"
TARGET="${TARGET:-}"

if [ "$TARGET" == "" ] && [ "${REMOTE_USER}" == "root" ]; then
    TARGET="/${REMOTE_USER}/workspace/"
elif [ "$TARGET" == "" ]; then
    TARGET="/home/${REMOTE_USER}/workspace/"
fi

CHOWN="--chown=${REMOTE_OWNER:-${REMOTE_USER}}:${REMOTE_GROUP:-${REMOTE_USER}}"
PORT_NUMBER="${REMOTE_PORT:-22}"

EXCLUDE_STRING="${EXCLUDE:-}"

# Use tr command to replace the delimiter character with a newline
EXCLUDE_ARRAY=$(echo $EXCLUDE_STRING | tr "," "\n")

EXCLUDE=""
for x in $EXCLUDE_ARRAY
do
    EXCLUDE="$EXCLUDE --exclude $x"
done

# Do deployment
sh -c "rsync -avz $EXCLUDE -e 'ssh -i $SSH_PATH/deploy_key -p 22' ${GITHUB_WORKSPACE}$SOURCE root@212.33.205.190:/home/wp-test"
