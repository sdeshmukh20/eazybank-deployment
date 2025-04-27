#!/bin/bash

source ./helper.sh

# Check if the environment name is provided
checkEnvArg "$1"

ENV_NAME=$1;

echo "Env Name in import-sql: $ENV_NAME"
# variables
DEFAULT_ENV_FILE="../../../env/eb_default.env"
ENV_SPECIFIC_FILE="../../../env/eb_${ENV_NAME}.env"

# Set up environment variables
log_info "Setting up environment variables."
if [ -f "$DEFAULT_ENV_FILE" ]; then
  # shellcheck source=/dev/null
  source "$DEFAULT_ENV_FILE"
else
  log_error "Default environment file not found: ${DEFAULT_ENV_FILE} from current-directory: $(pwd)"
  exit 1
fi

if [ -f "$ENV_SPECIFIC_FILE" ]; then
  # shellcheck source=/dev/null
  source "$ENV_SPECIFIC_FILE"
else
  log_error "Environment-specific file not found: ${ENV_SPECIFIC_FILE} from current-directory: $(pwd)"
  exit 1
fi