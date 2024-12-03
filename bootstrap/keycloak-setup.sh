#!/bin/bash

#configuration
export KEYCLOAK_HOME=${KEYCLOAK_HOME:-/Users/sdeshmukh/DEV/install/keycloak-26.0.4}
export PATH=$PATH:$KEYCLOAK_HOME/bin


KCL_HOST="localhost"
KCL_MNG_PORT="${PORT_KCL_MNG}"
KCL_OPS_PORT="${PORT_KCL_OPS}"
KCL_HEALTHCHECK_URL="http://$KCL_HOST:$KCL_MNG_PORT/health/ready"
KCL_BASE_URL="http://$KCL_HOST:$KCL_OPS_PORT"
KCL_MASTER_REALM="master"
KCL_ADMIN_USER="${KCL_ADMIN_USER}"
KCL_ADMIN_PASSWORD="${KCL_ADMIN_PSW}"
KCL_TARGET_REALM="eazybankdev"
KCL_TEST_USER="happy@example.com"
KCL_TEST_PASSWORD="User@123"

echo "==========================================================="
# Echo the variables
echo "KCL_HOST: $KCL_HOST"
echo "KCL_MNG_PORT: $KCL_MNG_PORT"
echo "KCL_OPS_PORT: $KCL_OPS_PORT"
echo "KCL_HEALTHCHECK_URL: $KCL_HEALTHCHECK_URL"
echo "KCL_BASE_URL: $KCL_BASE_URL"
echo "KCL_MASTER_REALM: $KCL_MASTER_REALM"
echo "KCL_ADMIN_USER: $KCL_ADMIN_USER"
echo "KCL_ADMIN_PASSWORD: $KCL_ADMIN_PASSWORD"
echo "KCL_TARGET_REALM: $KCL_TARGET_REALM"
echo "KCL_TEST_USER: $KCL_TEST_USER"
echo "KCL_TEST_PASSWORD: $KCL_TEST_PASSWORD"
echo "==========================================================="
# Configuration
export KEYCLOAK_HOME=${KEYCLOAK_HOME:-/Users/sdeshmukh/DEV/install/keycloak-26.0.4}
export PATH=$PATH:$KEYCLOAK_HOME/bin

# Function to check if Keycloak is healthy
function wait_for_keycloak() {
  echo "Waiting for Keycloak to become healthy at $KCL_HEALTHCHECK_URL..."

  # Print the curl command being executed
  echo "Executing: curl -s -o /dev/null -w \"%{http_code}\" \"$KCL_HEALTHCHECK_URL\""

  until [ "$(curl -s -o /dev/null -w "%{http_code}" "$KCL_HEALTHCHECK_URL")" -eq 200 ]; do
    echo "Keycloak is not ready yet. Retrying in 5 seconds..."
    sleep 5
  done

  echo "Keycloak is healthy!"
}

# Wait for Keycloak to be healthy
wait_for_keycloak

# Authenticate with Keycloak
echo "Authenticating with Keycloak..."
if ! kcadm.sh config credentials --server "$KCL_BASE_URL" --realm "$KCL_MASTER_REALM" --user "$KCL_ADMIN_USER" --password "$KCL_ADMIN_PASSWORD"; then
  echo "Authentication failed. Please check credentials and Keycloak server. Exiting."
  exit 1
fi

# Create or update a user in the eazybankdev realm
echo "Setting up Keycloak user in realm $KCL_TARGET_REALM..."
if ! kcadm.sh create users -r "$KCL_TARGET_REALM" -s username="$KCL_TEST_USER" -s enabled=true; then
  echo "Failed to create user $KCL_TEST_USER in realm $KCL_TARGET_REALM. Exiting."
  exit 1
fi

if ! kcadm.sh set-password -r "$KCL_TARGET_REALM" --username "$KCL_TEST_USER" --new-password "$KCL_TEST_PASSWORD"; then
  echo "Failed to set password for user $KCL_TEST_USER. Exiting."
  exit 1
fi

# Assign an ADMIN role to the user in eazybankdev realm
echo "Assigning ADMIN role to the user $KCL_TEST_USER in the realm $KCL_TARGET_REALM"
if ! kcadm.sh add-roles --uusername $KCL_TEST_USER --rolename ADMIN -r $KCL_TARGET_REALM; then
  echo "Failed to assign ADMIN role to the user $KCL_TEST_USER in the realm $KCL_TARGET_REALM. Exiting."
  exit 1
fi

# Assign an ADMIN role to the user in eazybankdev realm
echo "Assigning USER role to the user $KCL_TEST_USER in the realm $KCL_TARGET_REALM"
if ! kcadm.sh add-roles --uusername $KCL_TEST_USER --rolename USER -r $KCL_TARGET_REALM; then
  echo "Failed to assign USER role to the user $KCL_TEST_USER in the realm $KCL_TARGET_REALM. Exiting."
  exit 1
fi

# Create an USER role in the eazybankdev realm
echo "Setting up roles in the eazybankdev realm"
if ! kcadm.sh add-roles --uusername happy@example.com --rolename USER -r eazybankdev; then
  echo "Failed to create role USER in the realm $KCL_TARGET_REALM. Exiting."
  exit 1
fi

echo "Keycloak user setup complete."
