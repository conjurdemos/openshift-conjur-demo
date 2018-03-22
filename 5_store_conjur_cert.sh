#!/bin/bash 
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

set_project $CONJUR_PROJECT_NAME

echo "Retrieving Conjur certificate."

follower_pod_name=$(oc get pods -l role=follower --no-headers | awk '{ print $1 }' | head -1)
ssl_cert=$(oc exec $follower_pod_name -- cat /opt/conjur/etc/ssl/conjur.pem)

set_project $TEST_APP_PROJECT_NAME

echo "Storing non-secret conjur cert as configuration data"

# Write Conjur SSL cert in ConfigMap.
oc delete --ignore-not-found=true configmap $TEST_APP_PROJECT_NAME
oc create configmap $TEST_APP_PROJECT_NAME --from-file=ssl-certificate=<(echo "$ssl_cert")
