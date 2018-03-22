#!/bin/bash 
set -eou pipefail

if has_project "$TEST_APP_PROJECT_NAME"; then
  echo "Project '$TEST_APP_PROJECT_NAME' exists, not going to create it."
else
  echo "Creating '$TEST_APP_PROJECT_NAME' project."
  oc new-project $TEST_APP_PROJECT_NAME --description="For demonstration of Conjur container authentication and secrets retrieval."

  # Permissions
  oc policy add-role-to-user edit developer
fi
