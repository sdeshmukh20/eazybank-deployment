FROM mysql:8.0.41

# Declare build arguments
ARG EAZYBANK_ENV_NAME

# Copy initialization SQL scripts into the container
COPY service-config/mysql/generated/init-${EAZYBANK_ENV_NAME}.sql /docker-entrypoint-initdb.d/

# Display the contents
RUN echo "Displaying contents of init file: service-config/mysql/generated/init-${EAZYBANK_ENV_NAME}.sql" && \
    cat /docker-entrypoint-initdb.d/init-${EAZYBANK_ENV_NAME}.sql

# The MySQL image automatically executes scripts in this directory
