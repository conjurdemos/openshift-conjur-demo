#!/bin/bash 
set -eou pipefail

. ./utils.sh

announce "Creating Test App project."

if has_project "$TEST_APP_PROJECT_NAME"; then
  echo "Project '$TEST_APP_PROJECT_NAME' exists, not going to create it."
else
  echo "Creating '$TEST_APP_PROJECT_NAME' project."
  oc new-project $TEST_APP_PROJECT_NAME

  # Must run as root to write cert keys to disk.
  oc adm policy add-scc-to-user anyuid -z default
  
  # Permissions
  oc policy add-role-to-user edit developer
fi
