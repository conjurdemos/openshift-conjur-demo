#!/bin/bash 
set -o pipefail

. ../config.sh
. ../utils.sh

new_pwd=$(openssl rand -hex 12)

set_project $CONJUR_PROJECT

echo "Rotating password..."

oc exec $(get_master_pod_name) -- conjur variable values add db/password $new_pwd

echo "New db password is:" $new_pwd
