#!/bin/bash
set -eou pipefail

# Confirm Conjur OpenShift project name is configured.
if [ "$TEST_APP_PROJECT_NAME" = "" ]; then
  echo "You must set TEST_APP_PROJECT_NAME before running this script."
  exit 1
fi
