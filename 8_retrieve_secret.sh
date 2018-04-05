#!/bin/bash
set -eou pipefail

. ./utils.sh

set_project $TEST_APP_PROJECT_NAME

test_app_pod=$(oc get pods --no-headers | head -1 | awk '{ print $1 }')
test_app_secret=$(oc exec -c test-app $test_app_pod -- curl -s localhost)

announce "Secret retrieved by API test app\n$test_app_secret"

test_app_summon_pod=$(oc get pods --no-headers | tail -1 | awk '{ print $1 }')
test_app_summon_secret=$(oc exec -c test-app $test_app_summon_pod -- curl -s localhost)

announce "Secret retrieved by Summon test app\n$test_app_summon_secret"
