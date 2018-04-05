#!/bin/bash -e
set -eou pipefail

docker build -t test-app-api:$CONJUR_PROJECT_NAME .
