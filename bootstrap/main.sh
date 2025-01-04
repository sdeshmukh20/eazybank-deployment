#!/bin/bash

# Exit on any error
set -e
chmod +x ./scripts/helper.sh
source ./scripts/helper.sh

ENV_NAME="$1"

checkEnvArg $ENV_NAME

DEFAULT_ENV_FILE="../env/eb_default.env"
ENV_SPECIFIC_FILE="../env/eb_${ENV_NAME}.env"


# Set up environment variables
log_info "Setting up environment variables."
if [ -f "$DEFAULT_ENV_FILE" ]; then
  # shellcheck source=/dev/null
  source "$DEFAULT_ENV_FILE"
else
  log_error "Default environment file not found: $DEFAULT_ENV_FILE"
  exit 1
fi

if [ -f "$ENV_SPECIFIC_FILE" ]; then
  # shellcheck source=/dev/null
  source "$ENV_SPECIFIC_FILE"
else
  log_error "Environment-specific file not found: $ENV_SPECIFIC_FILE"
  exit 1
fi


# deploying eazybank system
cd scripts
#chmod +x ./set-env.sh
chmod +x ./build-eb-service.sh
chmod +x ./generate-mysql-script.sh
chmod +x ./build-image-ebs-mysql.sh
chmod +x ./run-service-containers.sh
chmod +x ./import_mysql_script.sh
chmod +x ./keycloak-setup.sh
chmod +x ./launch-web-client.sh

./build-eb-service.sh
./generate-mysql-script.sh "${ENV_NAME}"
./build-image-ebs-mysql.sh "$ENV_NAME"
./run-service-containers.sh "${ENV_NAME}"
./import_mysql_script.sh "${ENV_NAME}"
./keycloak-setup.sh "${ENV_NAME}"
./launch-web-client.sh "${ENV_NAME}"
cd ../