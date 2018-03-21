#!/bin/bash
set -eou pipefail

rm -rf openshift-conjur-deploy

# TODO: Change this to grab latest release once we do a release.
#git clone https://github.com/conjurinc/openshift-conjur-deploy

# Useful for temporarily working with a local project.
cp -r ../openshift-conjur-deploy ./openshift-conjur-deploy

pushd openshift-conjur-deploy
  ./start
popd
