# Kustomize

## Install Argo CD

### Prerequisites

- A Kubernetes cluster
- Kubectl
- kubie

### Install required release

To get a different Argo CD release in the [base/](./base) directory run the
[get-argocd-release-manifests.bash](../scripts/get-argocd-release-manifests.bash)
script.

```bash
bash get-argocd-release-manifests.bash v2.8.4
```

### Install required binaries

In the [scripts/](../scripts/) directory you can use the below scripts to
install the required binaries.

- get-argocd-cli.bash
- get-kustomize-cli.bash

```bash
bash get-argocd-cli.bash v2.8.4
bash get-kustomize-cli.bash v5.2.1
```

### Set repository credentials

All these can be set with Kustomize, but for security reasions we add them
manually. Create a env file with the required secret. Later in the
[kustomization file](overlays/poc/kustomization.yaml) it will be used to
create a secret. In this case we use
[PAT credentials][creating-a-personal-access-token] only with repo scope.
Create a env file with the credentials. Example:

```shell
cd overlays/poc
cat <<'EOF' > bboykov-repos-creds-secrets.env
username=bboykov
password=<token>
url=https://github.com/bboykov
type=git
EOF
```

Later this secret will be used in the Argocd CD configuration for access to GitHub.

[creating-a-personal-access-token]: https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token

### Deploy initially Argo CD

In this case we use Kustomize to deploy Argo CD. In
[overlays/poc/](./overlays/poc/) we define our overwrites (customizations) to
the base release. In the [argo-cd-cm.yaml](overlays/poc/argo-cd-cm.yaml) we
define our general Argo CD configuration. This includes repositories,
references to the repository credentials and more. See this
[example argo-cd-cm.yaml](https://argoproj.github.io/argo-cd/operator-manual/argocd-cm.yaml)
for all options.

Change the directory to [kustomize](./) directory.

```shell
cd kustomize/
kubectl create namespace argocd
kustomize build overlays/poc/ | kubectl apply -f -
```

Open the UI via port-forward

```shell
kubectl --namespace argocd port-forward svc/argocd-server 9099:80 &
open http://localhost:9099/
```

### Reset the Argo CD admin password and login

In this example we reset the admin password to "admin"

```shell
password="admin" && export bcrypted_pw="$(echo -n $(htpasswd -bnBC 10 "" ${password} | tr -d ':\n'))" && echo ${bcrypted_pw}
kubectl -n argocd patch secret argocd-secret \
  -p '{"stringData": {
    "admin.password": "'$bcrypted_pw'",
    "admin.passwordMtime": "'$(date +%FT%T%Z)'"
  }}'

argocd login localhost:9099
```

### Delete Argo CD

```shell
kustomize build overlays/poc/ | kubectl delete -f -
```

## Application deployment examples

### kube-prometheus-stack Helm repositry

```shell
cd kustomize
kubectl -n argocd apply -f ../../argocd-examples/helm/kube-prometheus-stack/kps.yaml

kubectl -n argocd delete -f ../../argocd-examples/helm/kube-prometheus-stack/kps.yaml
```

### ArgoCD self-management

```shell
cd kustomize
kubectl -n argocd apply -f ../../argocd-examples/argocd/argocd-app.yaml
```

### App of apps pattern

```shell
cd kustomize
kubectl -n argocd apply -f ../../argocd-examples/app-of-apps/app-of-apps.yaml
```
