#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/config.sh
. ./openshift-conjur-deploy/utils.sh

set_project $APP_PROJECT

oc secrets new-dockercfg dockerpullsecret \
   --docker-server=${DOCKER_REGISTRY_PATH} --docker-username=_ \
   --docker-password=$(oc whoami -t) --docker-email=_
oc secrets add serviceaccount/default secrets/dockerpullsecret --for=pull

docker_image=$DOCKER_REGISTRY_PATH/$APP_PROJECT/webapp:$CONJUR_DEPLOY_TAG

sed -e "s#{{ DOCKER_IMAGE }}#$docker_image#g" ./test_app/test_app.yaml | oc create -f -
