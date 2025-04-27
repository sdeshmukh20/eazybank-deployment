#!/bin/bash

# Exit on any error
set -e
chmod +x ./commands/build-image/build-image-ebs-app.sh
chmod +x ./commands/build-image/build-image-ebs-mysql.sh

chmod +x ./commands/util/helper.sh
chmod +x ./commands/util/import-env.sh

chmod +x ./commands/util/import-env.sh


chmod +x ./commands/build-eb-service.sh
chmod +x ./commands/launch-web-client.sh
chmod +x ./commands/keycloak-setup.sh

chmod +x ./commands/build-image.sh
chmod +x ./commands/generate-mysql-script.sh
chmod +x ./commands/display-port-forward-command.sh
chmod +x ./commands/import_mysql_script.sh
chmod +x ./commands/deploy-eb-system.sh
chmod +x ./commands/load-image-to-minikube.sh
chmod +x ./commands/minikube-manage-images.sh
chmod +x ./commands/undeploy-eb-system.sh
