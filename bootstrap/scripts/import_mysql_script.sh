#!/bin/bash
# Function to print log messages with color
log_info() {
  echo "$1"
}

log_error() {
  echo "$1"
}
log_info "Importing mysql data"
# Check if the environment name is provided
if [ -z "$1" ]; then
  log_error "Environment name is required (e.g., local, dev, uat). Exiting."
  exit 1
fi

ENV_NAME=$1;

# variables
DEFAULT_ENV_FILE="../../env/eb_default.env"
ENV_SPECIFIC_FILE="../../env/eb_${ENV_NAME}.env"

# Script to import a MySQL script with INSERT statements into a database.
export PATH="/usr/local/mysql/bin:$PATH"

log_info "Deploying for environment: $ENV_NAME"

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

# Configuration
DB_HOST="127.0.0.1"         # MySQL server host
DB_PORT="${PORT_MYSQL}"              # MySQL server port
DB_USER="root"     # MySQL username
DB_PASSWORD="${MYSQL_ROOT_PSW}" # MySQL password
DB_NAME="${MYSQL_APP_DB_NAME}"  # Target database
SQL_IMPORT_FILE="../../data/data.sql" # Path to the MySQL script file

# Check if SQL file exists
if [ ! -f "$SQL_IMPORT_FILE" ]; then
  echo "Error: SQL file '$SQL_IMPORT_FILE' not found!"
  exit 1
fi

# Import the SQL file
echo "Starting import of '$SQL_IMPORT_FILE' into database '$DB_NAME'..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$SQL_IMPORT_FILE"

if [ $? -eq 0 ]; then
  echo "Import completed successfully."
else
  echo "Error: Failed to import '$SQL_IMPORT_FILE'."
  exit 1
fi
