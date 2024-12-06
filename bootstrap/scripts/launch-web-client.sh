#!/bin/bash

# Function to print log messages with color
log_info() {
  echo "$1"
}

log_error() {
  echo "$1"
}
log_info "Setting-up sample user-data in keycloak"
# Check if the environment name is provided
if [ -z "$1" ]; then
  log_error "Environment name is required (e.g., local, dev, uat). Exiting."
  exit 1
fi

ENV_NAME=$1;

cd ../../../client-ui/eazy-bank-ui || { echo "Failed to enter eazy-bank-ui directory"; exit 1; }

npm install -g @angular/cli
ng serve --configuration="${ENV_NAME}"