#!/bin/bash
set -eo pipefail

# Confirm logged into OpenShift.
if ! oc whoami 2 > /dev/null; then
  echo "You must login to OpenShift before running this demo."
  exit 1
fi

# Confirm Conjur project name is configured.
if [ "$CONJUR_PROJECT_NAME" = "" ]; then
  echo "You must set CONJUR_PROJECT_NAME before running this script."
  exit 1
fi

# Confirm docker registry is configured.
if [ "$DOCKER_REGISTRY_PATH" = "" ]; then
  echo "You must set DOCKER_REGISTRY_PATH before running this script."
  exit 1
fi

# Confirm Conjur account is configured.
if [ "$CONJUR_ACCOUNT" = "" ]; then
  echo "You must set CONJUR_ACCOUNT before running this script."
  exit 1
fi

# Confirm Conjur admin password is configured.
if [ "$CONJUR_ADMIN_PASSWORD" = "" ]; then
  echo "You must set CONJUR_ADMIN_PASSWORD before running this script."
  exit 1
fi

# Confirm test app project name is configured.
if [ "$TEST_APP_PROJECT_NAME" = "" ]; then
  echo "You must set TEST_APP_PROJECT_NAME before running this script."
  exit 1
fi
