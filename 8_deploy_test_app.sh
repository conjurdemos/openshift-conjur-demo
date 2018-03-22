#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

set_project $TEST_APP_PROJECT_NAME

oc delete --ignore-not-found secrets dockerpullsecret

oc secrets new-dockercfg dockerpullsecret \
   --docker-server=${DOCKER_REGISTRY_PATH} --docker-username=_ \
   --docker-password=$(oc whoami -t) --docker-email=_
oc secrets add serviceaccount/default secrets/dockerpullsecret --for=pull

oc delete --ignore-not-found deploymentconfigs test-app

docker_image=$DOCKER_REGISTRY_PATH/$TEST_APP_PROJECT_NAME/test-app:$CONJUR_DEPLOY_TAG
sed -e "s#{{ DOCKER_IMAGE }}#$docker_image#g" ./test_app/test_app.yaml |
  sed -e "s#{{ CONJUR_ACCOUNT }}#$CONJUR_ACCOUNT#g" |
  sed -e "s#{{ CONJUR_PROJECT_NAME }}#$CONJUR_PROJECT_NAME#g" |
  sed -e "s#{{ CONFIG_MAP_NAME }}#$TEST_APP_PROJECT_NAME#g" |
  oc create -f -
