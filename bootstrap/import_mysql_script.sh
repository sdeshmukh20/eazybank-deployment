#!/bin/bash

# Script to import a MySQL script with INSERT statements into a database.
export PATH="/usr/local/mysql/bin:$PATH"

# Configuration
DB_HOST="127.0.0.1"         # MySQL server host
DB_PORT="${PORT_MYSQL}"              # MySQL server port
DB_USER="root"     # MySQL username
DB_PASSWORD="${MYSQL_ROOT_PSW}" # MySQL password
DB_NAME="${MYSQL_APP_DB_NAME}"  # Target database
SQL_FILE="${EB_DEPLOYMENT_HOME}/data/data.sql" # Path to the MySQL script file

# Check if SQL file exists
if [ ! -f "$SQL_FILE" ]; then
  echo "Error: SQL file '$SQL_FILE' not found!"
  exit 1
fi

# Import the SQL file
echo "Starting import of '$SQL_FILE' into database '$DB_NAME'..."
mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$SQL_FILE"

if [ $? -eq 0 ]; then
  echo "Import completed successfully."
else
  echo "Error: Failed to import '$SQL_FILE'."
  exit 1
fi
