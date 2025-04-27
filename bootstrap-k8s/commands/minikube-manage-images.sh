#!/bin/bash

# Exit on any error
set -e
source ./util/helper.sh

# Check if the environment name is provided
checkEnvArg "$1"

# Check if the second argument is provided
if [ -z "$2" ]; then
    log_error "Error: Second argument is required (must be 'mysql' or 'user-account')"
    exit 1
fi

# Check if the third argument is provided
if [ -z "$3" ]; then
    log_error "Error: Third argument(Version) is required (like v1, 2.2 etc')"
    exit 1
fi

# Validate the second argument
case "$2" in
    mysql)
        ./load-image-to-minikube.sh "localhost/ebs-mysql-app-$1:$3"
        ;;
    user-account)
        ./load-image-to-minikube.sh "localhost/ebs-user-account-app-$1:$3"
        ;;
    *)
        echo "Error: Invalid second argument. Must be 'mysql' or 'user-account'"
        exit 1
        ;;
esac
