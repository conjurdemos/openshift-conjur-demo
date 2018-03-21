#!/bin/bash 
set -eou pipefail

. ../config.sh
. ../utils.sh

set_project $APP_PROJECT

oc secrets new-dockercfg dockerpullsecret \
   --docker-server=${DOCKER_REGISTRY_PATH} --docker-username=_ \
   --docker-password=$(oc whoami -t) --docker-email=_
oc secrets add serviceaccount/default secrets/dockerpullsecret --for=pull

docker_image=$DOCKER_REGISTRY_PATH/$APP_PROJECT/webapp:$CONJUR_DEPLOY_TAG

sed -e "s#{{ DOCKER_IMAGE }}#$docker_image#g" ./webapp.yaml | oc create -f -
