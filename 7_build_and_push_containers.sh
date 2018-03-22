#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

docker login -u _ -p $(oc whoami -t) $DOCKER_REGISTRY_PATH

pushd test_app/build
  ./build.sh
popd

docker_tag_and_push $TEST_APP_PROJECT_NAME "test-app"
