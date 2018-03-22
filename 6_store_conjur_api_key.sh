#!/bin/bash 
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh

set_project $TEST_APP_PROJECT_NAME

oc delete --ignore-not-found=true secret conjur-test-app-api-key

set_project $CONJUR_PROJECT_NAME

# Rotate the test app's Conjur API key to get a new one.
api_key=$(oc exec $(get_master_pod_name) -- conjur host rotate_api_key -h 'conjur/openshift-12345/apps/test-app')

set_project $TEST_APP_PROJECT_NAME

# Store the API key in a Secret.
oc create secret generic conjur-test-app-api-key --from-literal "api-key=$api_key"
