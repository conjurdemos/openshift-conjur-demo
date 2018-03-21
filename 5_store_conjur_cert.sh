#!/bin/bash 
set -eou pipefail

. ./config.sh
. ./openshift-conjur-deploy/config.sh
. ./openshift-conjur-deploy/utils.sh

set_project $CONJUR_PROJECT

echo "Retrieving Conjur certificate."

ssl_cert=$(oc exec $(get_master_pod_name) -- cat /opt/conjur/etc/ssl/conjur.pem)

set_project $APP_PROJECT

echo "Storing non-secret conjur cert as configuration data"

# Write Conjur SSL cert in ConfigMap.
oc delete --ignore-not-found=true configmap $APP_PROJECT
oc create configmap $APP_PROJECT --from-file=ssl-certificate=<(echo "$ssl_cert")
