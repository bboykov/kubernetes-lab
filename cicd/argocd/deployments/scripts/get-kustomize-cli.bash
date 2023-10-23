#!/usr/bin/env bash
# Install kustomize Usage:
# Execute from the scripts directory and optionally provide version:
# ./get-kustomize.bash [v5.2.1]

set -euo pipefail
IFS=$'\n\t'


desired_version=${1:-v5.2.1}
install_dir="/usr/local/bin"
binary="kustomize"

cd /tmp/
wget "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh"
sudo bash install_kustomize.sh "${desired_version#v}"
rm install_kustomize.sh
sudo mv /tmp/${binary} ${install_dir}

echo "kustomize installed! Version:"
kustomize version
