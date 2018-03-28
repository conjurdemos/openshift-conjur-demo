#!/bin/bash
set -eou pipefail

. ./utils.sh

announce "Deploying test app."

set_project $TEST_APP_PROJECT_NAME

oc delete --ignore-not-found secrets dockerpullsecret

# Set credentials for Docker registry.
oc secrets new-dockercfg dockerpullsecret \
   --docker-server=${DOCKER_REGISTRY_PATH} --docker-username=_ \
   --docker-password=$(oc whoami -t) --docker-email=_
oc secrets add serviceaccount/default secrets/dockerpullsecret --for=pull

oc delete --ignore-not-found deploymentconfigs test-app

sleep 5

test_app_docker_image=$DOCKER_REGISTRY_PATH/$TEST_APP_PROJECT_NAME/test-app:$CONJUR_PROJECT_NAME

sed -e "s#{{ TEST_APP_DOCKER_IMAGE }}#$test_app_docker_image#g" ./test_app/test_app.yaml |
  sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
  sed -e "s#{{ CONJUR_PROJECT_NAME }}#$CONJUR_PROJECT_NAME#g" |
  sed -e "s#{{ TEST_APP_PROJECT_NAME }}#$TEST_APP_PROJECT_NAME#g" |
  sed -e "s#{{ SERVICE_ID }}#$AUTHENTICATOR_SERVICE_ID#g" |
  sed -e "s#{{ CONFIG_MAP_NAME }}#$TEST_APP_PROJECT_NAME#g" |
  oc create -f -

sleep 20

echo "Test app deployed."
