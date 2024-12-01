FROM mysql:8.0.33

# Declare build arguments
ARG EAZYBANK_ENV_NAME

# Copy initialization SQL scripts into the container
COPY service-config/mysql/generated/init-${EAZYBANK_ENV_NAME}.sql /docker-entrypoint-initdb.d/

# The MySQL image automatically executes scripts in this directory
