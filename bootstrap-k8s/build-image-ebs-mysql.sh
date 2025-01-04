#!/bin/bash

# Exit on any error
set -e
source ../bootstrap/scripts/helper.sh


# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME="$1"

DOCKER_COMPOSE_DIR="../docker"

# deploying eazybank system
cd "$DOCKER_COMPOSE_DIR"
IMAGE_NAME=ebs-mysql-app-$ENV_NAME:1.0;

log_info "Building > Ebs-Mysql-Service-Docker-Image:[$IMAGE_NAME]"
eval "$(minikube docker-env)"
docker build -f service-config/mysql/Dockerfile --build-arg EAZYBANK_ENV_NAME="$ENV_NAME" -t "$IMAGE_NAME" .

log_info "Build successfully > Ebs-Mysql-Service-Docker-Image:[$IMAGE_NAME]"