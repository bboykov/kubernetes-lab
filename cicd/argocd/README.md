# Argo CD

Argo CD is a declarative, GitOps continuous delivery tool for Kubernetes.

<!-- TOC GFM -->

- [Argo CD Research notes](#argo-cd-research-notes)
  - [Considerations](#considerations)
  - [Tracking and Deployment Strategies](#tracking-and-deployment-strategies)
    - [Helm](#helm)
      - [Helm repository](#helm-repository)
    - [Git repository](#git-repository)
  - [A GitOps anti-pattern - Dynamic Parameter Overrides](#a-gitops-anti-pattern---dynamic-parameter-overrides)
  - [Unexplored topics](#unexplored-topics)
  - [Conclusion](#conclusion)
- [Resources](#resources)

<!-- TOC -->

## Argo CD Research notes

Argo CD is using the Application core concept to manage applications deployment
and lifecycle. Inside an Argo CD application manifest you define the Git
repository hosting your application definitions, as well as the corresponding
Kubernetes cluster to deploy applications. In other words, an Argo CD
application defines the relationship between a source repository and a
Kubernetes cluster. It's a very concise and scalable design, where you can
associate multiple sources (Git repositories) and corresponding Kubernetes
clusters.

Reads:

- [Implementing GitOps using Argo CD](https://github.com/digitalocean/Kubernetes-Starter-Kit-Developers/blob/main/14-continuous-delivery-using-gitops/argocd.md)

### Considerations

- Deployment (Installation) methods
  - [Kustomize](./deployments/kustomize/). It is most convenient ,fast and recommended way for the ArgoCD installation(s).
  - [Helm](./deployments/helm). Via [Helm Chart](https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd)
- High Availability.
  The [Argo CD releases](https://github.com/argoproj/argo-cd/tree/v1.8.3/manifests/ha) have
  specially crafted HA manifests.
- Upgrades
  - It can self manage. It handles self updates and reverts.
  - Has import/export functionallity that can be used in DR senario.
- Deployment strategy
  - a) Central (infra cluster). One ArgoCD installation in a infra cluster to
    manage deployments on all clusters one central repo to hold the argo app
    objects. This might not work well for thousands of applications.
  - b) In-cluster. Every cluster has it's own ArgoCD installation that
    manages only that particular cluster. argo app objects can reside with the
    application repo.

### Tracking and Deployment Strategies

Details in the Argo CD documentation -
[Tracking and Deployment Strategies.](https://argoproj.github.io/argo-cd/user-guide/tracking_strategies/)

#### Helm

##### Helm repository

Every application has a Argo CD application resource that points to a Helm
Chart version. That is the place where you need to update to trigger
deployment/change. When the helm app version gets bumped (git commit) ArgoCD
detects.

See an example:

- [Nginx](./argocd-examples/helm/nginx/nginx-dev.yaml)

#### Git repository

This method is more flexable can do HEAD/Branch/Tag tracking or commit
pinning. The `spec.source.targetRevision` is set to branch/HEAD. Argo CD
scans the repository for changes.

See examples with Kustomize:

- [Guestbook demo application with Kustomize](./argocd-examples/kustomize-guestbook/)

Example with Helm. Instead of pointing to a chart version it scans the repo branch for changes and
deploys helm chart locally from the git repo without the need of helm
repository. See an example:

- [Guestbook demo application with Helm](./argocd-examples/helm/helm-git-guestbook/helm-git-guestbook-dev.yaml)

### A GitOps anti-pattern - Dynamic Parameter Overrides

Argo CD provides a mechanism to override the parameters of Argo CD
applications that leverages config management tools. This provides
flexibility in having most of the application manifests defined in Git, while
leaving room for some parts of the k8s manifests determined dynamically, or
outside of Git.

Many consider this mode of operation as an anti-pattern to GitOps, since the
source of truth becomes a union of the Git repository, and the application
overrides. The Argo CD parameter overrides feature is provided mainly as a
convenience to developers and is intended to be used in dev/test
environments, vs. production environments. More on the argo CD user guide
under ["Parameter Overrides".](https://argo-cd.readthedocs.io/en/stable/user-guide/parameters/)

### Unexplored topics

- Notifications. The notifications support is not bundled into the Argo CD
  itself. There are integrations that allow notification via Slack. See Argo
  CD docs for further details.
- Git Webhook Configuration. Argo CD polls Git repositories every three
  minutes to detect changes to the manifests. To eliminate this delay from
  polling, the API server can be configured to receive webhook events
- Argo CD backups (Disaster Recovery). You can use argocd-util to import and
  export all Argo CD data.
- Ingress Configuration
- Cluster Bootstrapping

### Conclusion

Pros:

- Using git as the Source of Truth.
- Declarative Deployments. Every aspect of the configuration can be held as k8s resource.
- Handling Configuration Drift.
- Rollbacks support.
- Can handle [Kubernetes manifests in many shapes and forms](https://argoproj.github.io/argo-cd/user-guide/application_sources/):
  - Helm Chart from Helm repo (https)
  - Helm Chart from git repo
  - Kustomize
  - Raw kubernetes yaml files
- Kubernetes-native.
- Application Health status.
- Real-time view of application activity.

Cons:

- There is no CI and Pipeline functionality. It needs the aid of another tool to
  provide that - Jenkins, CircleCI, Tekton, etc. There are some
  integrations in that regard.

Facts:

- In practice argocd becomes the package manager. Cannot use the Helm CLI. The
  Helm CLI cannot find a release. Argo CD takes the definitions and trainsforms
  it to K8s manifests, then it applies them into a Cluster. Still the argocd
  cli and kubectl can be used to manage a deployment.
  - [Unable to use helm CLI against helm releases that have been deployed by ArgoCD](https://github.com/argoproj/argo-cd/issues/1672).

The tool is flexible and can be used in many different ways. It would greatly
benefit the kubernetes user.

## Resources

- [Nice video intro to ArgoCD](https://www.youtube.com/watch?v=HX24uMKmJRw&list=PL34sAs7_26wMW4bWKnMIfEd87aPuw75by )
- [Argo CD documentation](https://argoproj.github.io/argo-cd/)
- [ArgoCD Example Apps](https://github.com/argoproj/argocd-example-apps)
- [Argo CD Helm Chart](https://github.com/argoproj/argo-helm/tree/master/charts/argo-cd)
- [Self Managed Argo CD — App Of Everything](https://medium.com/devopsturkiye/self-managed-argo-cd-app-of-everything-a226eb100cf0)
  - [Self Managed Argo CD - App of Everything repo](https://github.com/kurtburak/argocd)
