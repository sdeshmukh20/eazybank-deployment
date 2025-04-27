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
    log_error "Error: Third argument is required (must be version-name v1, v2, 3.3)"
    exit 1
fi
cd ./build-image
# Validate the second argument
case "$2" in
    mysql)
        ./build-image-ebs-mysql.sh "$1" "$3"
        ;;
    user-account)
        ./build-image-ebs-app.sh "$1" "$3"
        ;;
    *)
        echo "Error: Invalid second argument. Must be 'mysql' or 'user-account'"
        exit 1
        ;;
esac
cd ../