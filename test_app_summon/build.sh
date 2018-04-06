#!/bin/bash -e
set -eou pipefail

docker build -t test-app-summon:$CONJUR_PROJECT_NAME .
