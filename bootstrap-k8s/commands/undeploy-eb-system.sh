kubectl delete -f ../../kubernetes/deployment-ebs-user-account-service.yaml
kubectl delete -f ../../kubernetes/deployment-ebs-keycloak.yaml
kubectl delete -f ../../kubernetes/deployment-ebs-mysql.yaml
kubectl delete -f ../../kubernetes/configmap-ebs-keycloak-realm.yaml
kubectl delete -f ../../kubernetes/configmap-ebs-keycloak-custom-theme.yaml
