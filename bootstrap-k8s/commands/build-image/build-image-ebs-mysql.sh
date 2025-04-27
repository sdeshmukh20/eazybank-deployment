#!/bin/bash

# Exit on any error
set -e
source ../util/helper.sh


# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME="$1"

# Check if the second argument is provided
if [ -z "$2" ]; then
    log_error "Error: Third argument is required (must be version-name v1, v2, 3.3)"
    exit 1
fi



VERSION_NAME="$2"

DOCKER_COMPOSE_DIR="../../../docker"

# deploying eazybank system
cd "$DOCKER_COMPOSE_DIR"
IMAGE_NAME=ebs-mysql-app-$ENV_NAME:$VERSION_NAME;

log_info "Building > Ebs-Mysql-Service-Docker-Image:[$IMAGE_NAME]"

docker build --no-cache -f service-config/mysql/Dockerfile --build-arg EAZYBANK_ENV_NAME="$ENV_NAME" -t "$IMAGE_NAME" .

docker tag "$IMAGE_NAME" "localhost/$IMAGE_NAME"

log_info "Build successfully > Ebs-Mysql-Service-Docker-Image:[$IMAGE_NAME]"


#localhost/ebs-mysql-app-uat:1.0