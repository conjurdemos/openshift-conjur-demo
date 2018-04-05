# openshift-conjur-demo

This repo demonstrates an app retrieving secrets from a Conjur cluster using the
[Kubernetes authenticator](https://github.com/conjurinc/authn-k8s). The numbered
scripts perform the same setps that a user will have to go through when setting
up their own applications.

# Setup

### Deploying Conjur

Before running this demo you will need to [set up a Conjur cluster](https://github.com/conjurinc/openshift-conjur-deploy)
in your OpenShift environment. It is recommended that you **set up a separate
Conjur cluster** purely for the purpose of running this demo as it loads Conjur
policy that you would not want to be present in your production environment.

### Script Configuration

You will need to provide a name for the OpenShift project in which your test app
will be deployed:

```
export TEST_APP_PROJECT_NAME=test-app
```

You will also need to set several environment variables to match the values used
when configuring your Conjur deployment. Note that if you may already have these 
variables set if you're using the same shell to run the demo:

```
export CONJUR_PROJECT_NAME=<conjur-project-name>
export DOCKER_REGISTRY_PATH=docker-registry-<registry-namespace>.<routing-domain>
export CONJUR_ACCOUNT=<account-name>
export CONJUR_ADMIN_PASSWORD=<admin-password>
export AUTHENTICATOR_SERVICE_ID=<service-id>
```

# Usage

Run `./start` to execute the numbered scripts, which will start by configuring
Conjur and storing a secret value in a variable declared in Conjur policy. They
will then deploy two test apps that retrieve this secret in different ways.

Both test apps expose a single endpoint that can be curled to retrieve the
secret value. The API test app uses the [Conjur Ruby API](https://github.com/cyberark/conjur-api-ruby)
for secret retrieval and the Summon test app uses the open-source tool [Summon](https://cyberark.github.io/summon/).
The final numbered script makes curl requests to both of these test apps and displays the output.

You can also run the `./rotate` script to rotate the secret value and then run
the final numbered script again to retrieve and print the new value.