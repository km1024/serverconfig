#!/bin/bash
set -e

# Deployment Script for Checkinbot (from Server Config Repo)
#
# This script takes the pre-built application artifact (checkinbot.tar)
# and deploys it to the remote server.
#
# Usage:
# ./deploy-checkinbot.sh [REMOTE_USER] [REMOTE_HOST] [REMOTE_DIR]
#
# Alternatively, set environment variables:
# export REMOTE_USER="your_user"
# export REMOTE_HOST="your_host"
# export REMOTE_DIR="/path/to/your/app"
# ./deploy-checkinbot.sh

# --- Configuration ---
REMOTE_USER="${1:-$REMOTE_USER}"
REMOTE_HOST="${2:-$REMOTE_HOST}"
REMOTE_DIR="${3:-$REMOTE_DIR}"

LOCAL_TAR_PATH="/tmp/checkinbot.tar"
REMOTE_TAR_PATH="/tmp/checkinbot.tar"

# --- Validation ---
if [ -z "$REMOTE_USER" ] || [ -z "$REMOTE_HOST" ] || [ -z "$REMOTE_DIR" ]; then
  echo "Error: Missing deployment configuration."
  echo "Please provide arguments or set environment variables:"
  echo "Usage: $0 <REMOTE_USER> <REMOTE_HOST> <REMOTE_DIR>"
  echo "Or set: REMOTE_USER, REMOTE_HOST, REMOTE_DIR"
  exit 1
fi

if [ ! -f "$LOCAL_TAR_PATH" ]; then
    echo "Error: Build artifact not found at $LOCAL_TAR_PATH"
    echo "Please run the build.sh script from the application repository first."
    exit 1
fi

# --- Transfer ---
echo "Copying image to server: $REMOTE_USER@$REMOTE_HOST:$REMOTE_TAR_PATH..."
scp $LOCAL_TAR_PATH "$REMOTE_USER@$REMOTE_HOST:$REMOTE_TAR_PATH"

# --- Deploy ---
echo "Deploying on server..."
ssh "$REMOTE_USER@$REMOTE_HOST" << EOF
  set -e
  echo "Loading Docker image on server..."
  docker load -i $REMOTE_TAR_PATH

  echo "Restarting services with docker-compose..."
  cd $REMOTE_DIR
  docker-compose up -d

  echo "Cleaning up remote tar file..."
  rm $REMOTE_TAR_PATH
EOF

echo "Deployment finished successfully!"
