#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

### Installation documentation:
### https://argo-cd.readthedocs.io/en/stable/cli_installation/

if [[ "${OSTYPE}" == linux* ]]; then
  os_platform="linux"
  echo "Running on Linux"
elif [[ "${OSTYPE}" == darwin* ]]; then
  os_platform="darwin"
  arch_name="$(uname -m)"
  if [ "${arch_name}" = "x86_64" ]; then
      if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
          echo "Running on Rosetta 2"
          arch_codename="amd64"
      else
          echo "Running on native Intel"
          arch_codename="amd64"
      fi
  elif [ "${arch_name}" = "arm64" ]; then
      echo "Running on ARM"
          arch_codename="arm64"
  else
      echo "Unknown architecture: ${arch_name}"
      exit 1
  fi
else
  echo "OS type ${OSTYPE} not supported by the script. Exiting."
  exit 1
fi

DESIRED_VERSION="${1:-v2.8.4}" # Select desired TAG from https://github.com/argoproj/argo-cd/releases
INSTALL_DIR="/usr/local/bin"

curl -sSL -o argocd "https://github.com/argoproj/argo-cd/releases/download/${DESIRED_VERSION}/argocd-${os_platform}-${arch_codename}"
sudo install -m 555 argocd "${INSTALL_DIR}/argocd"
rm argocd

echo "argocd cli installed! Version:"
argocd version --client
