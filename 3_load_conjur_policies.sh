#!/bin/bash
set -eou pipefail

. ./openshift-conjur-deploy/utils.sh
. ./utils.sh

conjur_master=$(get_master_pod_name)

# (re)install Conjur policy plugin
oc exec $conjur_master -- touch /opt/conjur/etc/plugins.yml
oc exec $conjur_master -- conjur plugin uninstall policy
oc exec $conjur_master -- conjur plugin install policy

oc rsync ./policy $conjur_master:/

oc exec $conjur_master -- conjur authn login -u admin -p $CONJUR_ADMIN_PASSWORD

# Load the users policies, which would be managed by the Ops team.
oc exec $conjur_master -- conjur policy load --as-group security_admin "policy/users.yml"

# Load the OpenShift app policies, which are performed by the OpenShift admin.
oc exec $conjur_master -- conjur policy load --as-group security_admin "policy/openshift_apps.yml"

# Load the application policies, which would be managed by an application team.
oc exec $conjur_master -- conjur policy load --as-group security_admin "policy/test_app.yml"

# Load the database policies, which would be managed by a DBA team.
oc exec $conjur_master -- conjur policy load --as-group security_admin "policy/db.yml"

oc exec $conjur_master -- rm -rf ./policy

password=$(openssl rand -hex 12)

echo "Setting DB password: $password"
oc exec $conjur_master -- conjur variable values add db/password $password
