# Server Deployment Guide

This guide explains how to deploy the `checkinbot` application artifact to the production server. This process should be run from your `server-config` repository after the application artifact has been built.

## Prerequisites

1.  **Application Artifact:** You must first build the application by running the `build.sh` script in the `elonbot` application repository. This will create the required `/tmp/checkinbot.tar` file.
2.  **SSH Access:** You must have passwordless SSH access to the remote server (e.g., using SSH keys).
3.  **Docker:** Docker and `docker-compose` must be installed on the remote server.

## Deployment Script

The `deploy-checkinbot.sh` script automates the transfer and deployment of the application.

### Usage

The script requires three pieces of information:
*   **Remote User:** The username for SSH and SCP.
*   **Remote Host:** The server's hostname or IP address.
*   **Remote Directory:** The absolute path on the server where your `docker-compose.yml` file is located.

You can provide these either as command-line arguments or as environment variables.

**1. Using Command-Line Arguments (Recommended):**

```bash
./deploy-checkinbot.sh <your_user> <your_host> /path/to/your/app
```

**Example:**
```bash
./deploy-checkinbot.sh ubuntu 192.168.1.100 /home/ubuntu/elonbot
```

**2. Using Environment Variables:**

Export the variables in your shell, then run the script.

```bash
export REMOTE_USER="ubuntu"
export REMOTE_HOST="192.168.1.100"
export REMOTE_DIR="/home/ubuntu/elonbot"

./deploy-checkinbot.sh
```
