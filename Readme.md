
# Launch EazyBank System

This guide provides instructions to set up and launch EazyBank System using containerization. Follow the steps below to configure environment variables, start the services, and initialize Keycloak data.

---

## 1. Setup Environment Variables

Navigate to the `init` directory and configure the environment variables.

```bash
cd eazybank-deployment
cd init
```

### Generate Environment Variables

Run the script to generate environment variables:

```bash
./set-env.sh dev
```

### Apply Environment Variables

Source the generated environment variables file:

```bash
source ../output/generated_vars_dev.env
```

---

## 2. Launch Services through Containerization

Navigate to the `docker` directory and start the services:

```bash
cd ../docker
docker compose -p env_dev down --volume
docker compose -p env_dev up --build
```

---

## 3. Verify Docker Services

Ensure that all Docker services are up and running:

```bash
docker compose -p env_dev ps
```

---

## 4. Setup Keycloak Data

Run the Keycloak setup script:

```bash
cd ../bootstrap
./keycloak-setup.sh
```

---

### Notes
- Ensure Docker and Docker Compose are installed on your system.
- Make sure you have the necessary permissions to execute the scripts.
- For troubleshooting or additional configuration, refer to the respective service documentation.
