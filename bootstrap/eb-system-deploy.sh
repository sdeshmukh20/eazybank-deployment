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

# Variables
DEPLOY_DIR="$(pwd)"
DEFAULT_ENV_FILE="../env/eb_default.env"
ENV_SPECIFIC_FILE="../env/eb_${ENV_NAME}.env"

echo "ENV_SPECIFIC_FILE: ${ENV_SPECIFIC_FILE}"
SERVICE_DIR="/Users/sdeshmukh/DEV/visionmax/syestem24/services/eazybank-service"
DEPLOYMENT_BUILD_DIR="../docker/service-config/app/build"
MYSQL_GENERATED_DIR="../docker/service-config/mysql/generated"
INIT_TEMPLATE_FILE="../docker/service-config/mysql/init-template.sql"
DOCKER_COMPOSE_DIR="../docker"





log_info "Deploying for environment: $ENV_NAME"

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

cd "${DEPLOY_DIR}"
# Prepare the SQL init file
log_info "Preparing the SQL init file..."
mkdir -p "$MYSQL_GENERATED_DIR"
envsubst < "$INIT_TEMPLATE_FILE" > "$MYSQL_GENERATED_DIR/init-${ENV_NAME}.sql" || {
  log_error "Failed to generate SQL init file."
  exit 1
}

# Run the `up` command in detached mode
cd "$DOCKER_COMPOSE_DIR"
log_info "Docker compose down if running:"
docker compose -p "env_${ENV_NAME}" down --volumes || { log_error "Docker compose failed to down."; exit 1; }
log_info "Docker compose getting  up the services"
docker compose -p "env_${ENV_NAME}" up --build -d || { log_error "Docker compose failed."; exit 1; }

log_info "Docker compose is running in detached mode. Showing container status:"
docker compose -p "env_${ENV_NAME}" ps

log_info "Script execution completed. Containers are running in detached mode."