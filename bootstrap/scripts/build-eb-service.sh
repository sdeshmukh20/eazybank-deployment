#!/bin/bash

# Exit on any error
set -e
source ./helper.sh
SERVICE_DIR="../../../../services/eazybank-service"
DEPLOYMENT_BUILD_DIR="../../docker/service-config/app/build"

# Build eazybank-service
log_info "Building eazybank-service with Maven..."
cd "$SERVICE_DIR" || { log_error "Failed to enter service directory: $SERVICE_DIR"; exit 1; }
mvn clean install -Dmaven.test.skip=true || { log_error "Maven build failed."; exit 1; }

# Copy the target jar to the deployment directory
log_info "Copying the built jar to the deployment build directory..."
TARGET_JAR=$(find target -type f -name "*.jar" | grep -v "original")
if [ -z "$TARGET_JAR" ]; then
  log_error "No JAR file found in target directory."
  exit 1
fi

mkdir -p "$DEPLOYMENT_BUILD_DIR"
cp "$TARGET_JAR" "$DEPLOYMENT_BUILD_DIR" || { log_error "Failed to copy the JAR file."; exit 1; }
