#!/bin/bash
set -eou pipefail

. ./utils.sh

announce "Retrieving secret using Conjur access token."

set_project $TEST_APP_PROJECT_NAME

test_app_pod=$(oc get pods --no-headers | awk '{ print $1 }')

oc exec -c test-app $test_app_pod -- curl -s localhost
