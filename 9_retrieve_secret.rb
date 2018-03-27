#!/bin/bash
set -eou pipefail

test_app_pod=$(oc get pods --no-headers | awk '{ print $1 }')

oc exec -c test-app $test_app_pod -- curl -s localhost
