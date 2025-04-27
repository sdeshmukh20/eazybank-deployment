#!/bin/bash

# Function to print log messages with color
log_info() {
  echo "$1"
}

log_error() {
  echo "$1"
}

checkEnvArg(){
  # Check if the environment name is provided
  if [ -z "$1" ]; then
    log_error "Environment name is required (e.g., local, dev, uat). Exiting."
    exit 1
  fi
}