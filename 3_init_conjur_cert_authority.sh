#!/bin/bash
set -eou pipefail

. ./utils.sh

announce "Initializing Conjur certificate authority."

set_project $CONJUR_PROJECT_NAME

conjur_master=$(get_master_pod_name)

oc exec $conjur_master -- bash -c <<-EOF
# Generate OpenSSL private key
openssl genrsa -out ca.key 2048

CONFIG="
[ req ]
distinguished_name = dn
x509_extensions = v3_ca
[ dn ]
[ v3_ca ]
basicConstraints = critical,CA:TRUE
subjectKeyIdentifier   = hash
authorityKeyIdentifier = keyid:always,issuer:always
"

# Generate root CA certificate
openssl req -x509 -new -nodes -key ca.key -sha1 -days 3650 -set_serial 0x0 -out ca.cert \
  -subj "/CN=conjur.authn-k8s.$AUTHENTICATOR_SERVICE_ID/OU=Conjur Kubernetes CA/O=$CONJUR_ACCOUNT" \
  -config <(echo "$CONFIG")

# Verify cert
openssl x509 -in ca.cert -text -noout

# Load variable values
conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_SERVICE_ID/ca/key "$(cat ca.key)"
conjur variable values add conjur/authn-k8s/$AUTHENTICATOR_SERVICE_ID/ca/cert "$(cat ca.cert)"
EOF
# oc exec $conjur_master -- conjur-plugin-service authn-k8s rake ca:initialize["conjur/authn-k8s/$AUTHENTICATOR_SERVICE_ID"] > /dev/null

echo "Certificate authority initialized."
