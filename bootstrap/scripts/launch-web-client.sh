#!/bin/bash

source ./helper.sh
log_info "Setting-up sample user-data in keycloak"
# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME=$1;

cd ../../../../client-ui/eazy-bank-ui || { echo "Failed to enter eazy-bank-ui directory from current-directory:$(pwd)"; exit 1; }

npm install -g @angular/cli
npm install
# Run ng serve in the background and detach it
ng serve --configuration="${ENV_NAME}" > ng-serve.log 2>&1 &

# Get the PID of the background process
NG_SERVE_PID=$!

echo "ng serve is running in the background with PID: $NG_SERVE_PID"
echo "Logs are being written to ng-serve.log"