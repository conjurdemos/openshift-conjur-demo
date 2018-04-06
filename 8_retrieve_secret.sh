#!/bin/bash
set -eou pipefail

. ./utils.sh

set_project $TEST_APP_PROJECT_NAME

test_app_api_pod=$(oc get pods --no-headers | head -1 | awk '{ print $1 }')
test_app_api_secret=$(oc exec -c test-app $test_app_api_pod -- curl -s localhost)

test_app_summon_pod=$(oc get pods --no-headers | tail -1 | awk '{ print $1 }')
test_app_summon_secret=$(oc exec -c test-app $test_app_summon_pod -- curl -s localhost)

announce "Retrieved value for secret test-app-db/password:\n- with Ruby API: $test_app_api_secret\n- with Summon: $test_app_summon_secret"
