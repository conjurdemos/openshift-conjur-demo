#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

docker login -u _ -p $(oc whoami -t) $DOCKER_REGISTRY_PATH

# Test app image
pushd test_app/build
  ./build.sh
popd
docker_tag_and_push $TEST_APP_PROJECT_NAME test-app

# Sidecar image
docker pull cyberark/conjur-openshift-authenticator
docker tag cyberark/conjur-openshift-authenticator:latest conjur-openshift-authenticator:local
docker_tag_and_push $TEST_APP_PROJECT_NAME conjur-openshift-authenticator
