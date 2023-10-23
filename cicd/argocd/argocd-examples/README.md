# Argo CD applications

This direcotry holds Argo CD custom application resources that register
application deployment instances into Argo CD deployment.

## Apply the Argo CD application resources

```shell
kustomize build ../argocd-examples/ | kubectl apply -f -
```

## Delete the Argo CD application resources

```shell
kustomize build ../argocd-examples/ | kubectl delete -f -
```
