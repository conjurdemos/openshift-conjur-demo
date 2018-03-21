#!/bin/bash
set -eou pipefail

# Confirm logged into OpenShift.
if ! oc whoami 2 > /dev/null; then
  echo "You must login to OpenShift before running this demo."
  exit 1
fi

# Confirm docker registry is configured.
if [ "$DOCKER_REGISTRY_PATH" = "" ]; then
  echo "You must set DOCKER_REGISTRY_PATH before running this script."
  exit 1
fi
