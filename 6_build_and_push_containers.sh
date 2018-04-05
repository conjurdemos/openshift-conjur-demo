#!/bin/bash
set -eou pipefail

. ./utils.sh

announce "Building and pushing test app image."

docker login -u _ -p $(oc whoami -t) $DOCKER_REGISTRY_PATH

pushd test_app
  ./build.sh
popd
  
docker_tag_and_push $TEST_APP_PROJECT_NAME test-app

pushd test_app_summon
  ./build.sh
popd
  
docker_tag_and_push $TEST_APP_PROJECT_NAME test-app-summon
