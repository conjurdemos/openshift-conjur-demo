#!/bin/bash 
set -eou pipefail

. ./utils.sh

announce "Rotating password."

new_pwd=$(openssl rand -hex 12)

set_project $CONJUR_PROJECT_NAME

oc exec $(get_master_pod_name) -- conjur variable values add test-app-db/password $new_pwd

echo "New db password is:" $new_pwd
