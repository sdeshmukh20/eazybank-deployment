#!/bin/bash

# Exit on any error
set -e
source ./helper.sh
# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME="$1"

# Variables
DOCKER_COMPOSE_DIR="../../docker"

log_info "Deploying for environment: $ENV_NAME"

# Run the `up` command in detached mode
cd "$DOCKER_COMPOSE_DIR"
log_info "Docker compose down if running:"
docker compose -p "${ENV_NAME}" down --volumes || { log_error "Docker compose failed to down."; exit 1; }
log_info "Docker compose getting  up the services"
docker compose -p "${ENV_NAME}" up --build -d || { log_error "Docker compose failed."; exit 1; }

log_info "Docker compose is running in detached mode. Showing container status:"
docker compose -p "${ENV_NAME}" ps

log_info "Script execution completed. Containers are running in detached mode."