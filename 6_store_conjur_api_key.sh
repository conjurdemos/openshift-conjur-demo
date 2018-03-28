#!/bin/bash 
set -eou pipefail

. ./utils.sh

announce "Storing Conjur API key for test app configuration."

set_project $CONJUR_PROJECT_NAME

# Rotate the test app's Conjur API key to get a new one.
host_id=conjur/authn-k8s/$AUTHENTICATOR_SERVICE_ID/apps/$TEST_APP_PROJECT_NAME/*/*
api_key=$(oc exec $(get_master_pod_name) -- conjur host rotate_api_key -h $host_id)

set_project $TEST_APP_PROJECT_NAME

oc delete --ignore-not-found=true secret conjur-test-app-api-keys

# Store the API key in a Secret.
oc create secret generic conjur-test-app-api-key --from-literal "api-key=$api_key"

echo "Conjur API key stored."
