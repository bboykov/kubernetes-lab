# Kind

This direcory contains automation to setup local Kubernetes cluster via
[kind](https://github.com/kubernetes-sigs/kind)

Scripts:

- `get-kind` - pulls given version of kind.
- `manage-cluster` - Create or delete kind cluster.
- `/tmp/local-kind-task1-cluster` - kind cluster configuration file produced
  from the `manage-cluster` script.

## Create the cluster

1. Get kind via the provided script:

    ```bash
    cd kind/
    ./get-kind
    ```

1. Create a cluster

    ```bash
    ./manage-cluster create
    ```

    The command above will create a kind cluster, bring up a local docker
    registry and will install ingress nginx controller.

## Delete the cluster

Delete the cluster and the docker registry with:

```bash
./manage-cluster delete
```
