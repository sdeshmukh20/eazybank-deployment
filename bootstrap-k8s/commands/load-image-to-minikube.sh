#!/bin/bash

# Exit on any error
set -e
source ./util/helper.sh


# Check if the environment name is provided
checkEnvArg "$1"

IMAGE_NAME="$1"

log_info "Loading [$IMAGE_NAME] to minikube"

minikube image load "$IMAGE_NAME"

log_info "Loaded successfully in minikube> [$IMAGE_NAME]"

