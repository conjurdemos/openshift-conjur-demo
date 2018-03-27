# openshift-conjur-demo

This repo demonstrates secret retrieval from a Conjur cluster using the [Kubernetes authenticator](https://github.com/conjurinc/authn-k8s).


Conjur OpenShift integration by deploying Conjur using the scripts in the [openshift-conjur-deploy repo](https://github.com/conjurinc/openshift-conjur-deploy), loading some example Conjur policy, and deploying a simple test app that retrieves a database password and prints the password to its logs.

## Requirements

Before running this demo you will need to set up a Conjur cluster in your OpenShift environment. It is recommended that you **set up a separate Conjur cluster** purely for the purpose of running this demo as it loads Conjur policy that you would not want to be present in your production environment.

## Configuration

You will need to set the following environment variables to match the values used when setting up your Conjur deployment:

```
export CONJUR_PROJECT_NAME=conjur-demo
export DOCKER_REGISTRY_PATH=docker-registry-[registry pod namespace].apps.[openshift env domain]
export CONJUR_ACCOUNT=<my_account_name>
export CONJUR_ADMIN_PASSWORD=<my_admin_password>
export AUTHENTICATOR_SERVICE_ID=gke/prod
```

You will also need to provide a name for the test-app OpenShift project:

```
export TEST_APP_PROJECT_NAME=test-app
```

## Usage

Run the `./start` script to kick off the demo. It first loads Conjur policy and then deploys a test app container alongside a sidecar. The sidecar authenticates with Conjur and injects an access token into shared memory, which th test app then uses to retrieve a secret value from Conjur.

Please note that these scripts currently overprivilege the `default` service account with the `anyuid` SCC to allow it to write files to disk. This privilege will become more restricted in future iterations of this project.