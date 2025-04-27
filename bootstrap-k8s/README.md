Bootstrap commands:
1. sh main.sh -env uat -action build -svc ebapp
2. sh main.sh -env uat -action generate-mysql-script
3. sh main.sh -env uat -action build-image -svc user-account -version 1.2
4. sh main.sh -env uat -action build-image -svc mysql -version 1.2
5. sh main.sh -env uat -action load-minikube-image -svc user-account -version 1.2
6. sh main.sh -env uat -action load-minikube-image -svc mysql -version 1.2
7. sh main.sh -env uat -action deploy
8. sh main.sh -env uat -action display-port-fw-cmds
9. sh main.sh -env uat -action keycloak-setup
10. sh main.sh -env uat -action import-init-sql-data
11. sh main.sh -env uat -action launch-web-client
12. sh main.sh -env uat -action undeploy







Helper commands:
kubectl exec -it mysql-client -- sh
sh-5.1# mysql -h ebs-mysql-sv -uroot -p
