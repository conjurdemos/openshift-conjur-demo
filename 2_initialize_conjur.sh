#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/config.sh
. ./openshift-conjur-deploy/utils.sh

oc project $CONJUR_PROJECT
    
conjur_master=$(get_master_pod_name)
    
oc exec $conjur_master -- rm -f $CONJURRC $CONJUR_CERT_PATH
oc exec $conjur_master -- bash -c 'yes yes | conjur init -h localhost'
oc exec $conjur_master -- conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD
oc exec $conjur_master -- conjur bootstrap
oc exec $conjur_master -- conjur authn logout
