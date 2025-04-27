#!/bin/bash
# Requires environment-name as argument
# Exit on any error
set -e

cd ./util || {
  echo "Error: Failed to cd into ./util" >&2
  exit 1
}
source ./helper.sh

# Check if the environment name is provided
checkEnvArg "$1"

source ./import-env.sh "$1"

cd ../

pwd

GENERATED_DIR="../../generated"
TEMPLATE_FILE="../../templates/init-pfw-template.txt"

# Prepare the SQL init file
pwd
log_info "Generating port-forward commands..."
mkdir -p "$GENERATED_DIR"
envsubst < "$TEMPLATE_FILE" > "$GENERATED_DIR/port-forward-${ENV_NAME}.sh" || {
  log_error "Failed to generate Port Forward Commands."
  exit 1
}

echo "Port-Forward Commands:"
cat "$GENERATED_DIR/port-forward-${ENV_NAME}.sh"
echo "================="