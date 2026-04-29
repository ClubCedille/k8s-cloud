# k8s-cloud
Déploiement sur le cloud pour la Platforme Cedille

# Acces
Pour que le pipeline puisse accéder Kubernetes, il nécessite une configuration
que l'on garde dans les secrets sous KUBECONFIG

Ce fichier est généré avec la commande suivante pour chaque cluster :
```bash
omnictl kubeconfig --service-account gatus@serviceaccount.omni.sidero.dev --cluster <Nom de Cluster> --user gatus
```
Par défaut, `omnictl` va merge les configurations ensemble

On peut trouver les clusters ainsi :
```bash
omnictl get clusters
```
