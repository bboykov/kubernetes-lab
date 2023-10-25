# Helm

## Install Argo CD

### Prerequisites

- A Kubernetes cluster
- Kubectl
- helm
- kubie

### Install required release

### Install required binaries

In the [scripts/](../scripts/) directory you can use the below scripts to
install the required binaries.

- get-argocd-cli.bash
- get-helm-cli.bash

```bash
bash get-argocd-cli.bash v2.8.4
bash get-helm-cli.bash v3.13.0
```

### Set repository credentials

For security reasions we add repository credentials
manually. Create a env file with the required secret.
[PAT credentials][creating-a-personal-access-token] only with repo scope.


Change the directory to [secrets](../secrets/)directory. Create a env file with
the credentials. Example:

```shell
cat <<'EOF' > bboykov-repos-creds-secrets.env
username=bboykov
password=<token>
url=https://github.com/bboykov
type=git
EOF
```

Apply the secret in the cluster:

```shell
kustomize build ../secrets/. | kubectl apply -f -
```

Later this secret will be used in the Argocd CD configuration for access to
GitHub. [creating-a-personal-access-token]: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

### Deploy initially Argo CD

In this case we use Helm to deploy Argo CD.

Change the directory to [scripts](../scripts/) directory.

```shell
cd ../scripts/
```

```shell
bash install-argocd-via-helm.bash
```

Open the UI via port-forward

```shell
kubectl --namespace argocd port-forward svc/argocd-server 9099:80 &
open http://localhost:9099/ # pw is admin. It is set in the override value file
```

### [WIP] Delete Argo CD

```shell
helm -n argocd uninstall argocd
```

## Application deployment examples

CD in to the [helm](../helm/) directory.

### kube-prometheus-stack Helm repositry

Create

```shell
kubectl -n argocd apply -f ../../argocd-examples/helm/kube-prometheus-stack/kps.yaml
```

Delete

```shell
kubectl -n argocd delete -f ../../argocd-examples/helm/kube-prometheus-stack/kps.yaml
```

### ArgoCD self-management

```shell
kubectl -n argocd apply -f ../../argocd-examples/argocd/helm/argocd-app.yaml
```

### App of apps pattern

```shell
kubectl -n argocd apply -f ../../argocd-examples/app-of-apps/app-of-apps.yaml
```
