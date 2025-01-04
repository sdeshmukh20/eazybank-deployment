#!/bin/bash
# Requires environment-name as argument
# Exit on any error
set -e

source ./helper.sh

# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME="$1"
MYSQL_GENERATED_DIR="../../docker/service-config/mysql/generated"
INIT_TEMPLATE_FILE="../../docker/service-config/mysql/init-template.sql"

# Prepare the SQL init file
log_info "Preparing the SQL init file..."
mkdir -p "$MYSQL_GENERATED_DIR"
envsubst < "$INIT_TEMPLATE_FILE" > "$MYSQL_GENERATED_DIR/init-${ENV_NAME}.sql" || {
  log_error "Failed to generate SQL init file."
  exit 1
}