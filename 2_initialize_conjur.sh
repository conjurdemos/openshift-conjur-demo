#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

oc project $CONJUR_PROJECT_NAME
    
conjur_master=$(get_master_pod_name)
    
oc exec $conjur_master -- rm -f ./conjurrc "./conjur-${CONJUR_ACCOUNT}.pem"
oc exec $conjur_master -- bash -c 'yes yes | conjur init -h localhost'
oc exec $conjur_master -- conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD
oc exec $conjur_master -- conjur bootstrap
oc exec $conjur_master -- conjur authn logout

oc exec $conjur_master -- conjur-plugin-service authn-k8s rake ca:initialize["conjur/authn-k8s/openshift-test"]
