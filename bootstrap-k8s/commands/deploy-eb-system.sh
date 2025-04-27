
kubectl apply -f ../../kubernetes/configmap-ebs-keycloak-custom-theme.yaml

kubectl apply -f ../../kubernetes/configmap-ebs-keycloak-realm.yaml

kubectl apply -f ../../kubernetes/deployment-ebs-mysql.yaml

kubectl apply -f ../../kubernetes/deployment-ebs-keycloak.yaml

kubectl apply -f ../../kubernetes/deployment-ebs-user-account-service.yaml
