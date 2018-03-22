# openshift-conjur-demo

This repo demonstrates the Conjur OpenShift integration by deploying Conjur using the scripts in the [openshift-conjur-deploy repo](https://github.com/conjurinc/openshift-conjur-deploy), loading some example Conjur policy, and deploying a simple test app that retrieves a database password and prints the password to its logs.

## Setup

You will need to set the following environment variables for the openshift-conjur-deploy scripts to work correctly. See the [openshift-conjur-deploy README](https://github.com/conjurinc/openshift-conjur-deploy/blob/master/README.md) for more details. If you have already deployed Conjur to your OpenShift environment, it is recommended that you use a different `CONJUR_PROJECT_NAME` for the purposes of this demo.

```
export CONJUR_PROJECT_NAME=conjur-demo
export DOCKER_REGISTRY_PATH=docker-registry-default.apps.openshift33.itci.conjur.net
export CONJUR_ACCOUNT=awesome-org
export CONJUR_ADMIN_PASSWORD=very-secure-password
```

You will also need to provide a name for the test-app OpenShift project:

```
export TEST_APP_PROJECT_NAME=test-app
```