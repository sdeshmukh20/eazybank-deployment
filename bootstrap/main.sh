#!/bin/bash

# Exit on any error
set -e

# Function to print log messages with color
log_info() {
  echo "$1"
}

log_error() {
  echo "$1"
}


# Check if the environment name is provided
if [ -z "$1" ]; then
  log_error "Environment name is required (e.g., local, dev, uat). Exiting."
  exit 1
fi

ENV_NAME="$1"

# deploying eazybank system
cd scripts
chmod +x ./eb-system-deploy.sh
chmod +x ./import_mysql_script.sh
chmod +x ./keycloak-setup.sh
chmod +x ./launch-web-client.sh

#./eb-system-deploy.sh "${ENV_NAME}"
#./import_mysql_script.sh "${ENV_NAME}"
#./keycloak-setup.sh "${ENV_NAME}"
./launch-web-client.sh "${ENV_NAME}"
cd ../