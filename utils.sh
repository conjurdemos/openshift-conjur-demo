#!/bin/bash

announce() {
  printf "++++++++++++++++++++++++++++++++++++++\n"
  printf "\n"
  printf "$@\n"
  printf "\n"
  printf "++++++++++++++++++++++++++++++++++++++\n"
}

has_project() {
  if oc projects | awk 'n>=1 { print a[n%1] } { a[n%1]=$0; n=n+1 }' | sed 's/^ *//g' | grep -x "$1" > /dev/null ; then
    true
  else
    false
  fi
}

docker_tag_and_push() {
  docker_tag="${DOCKER_REGISTRY_PATH}/$1/$2:$CONJUR_PROJECT_NAME"
  docker tag $2:$CONJUR_PROJECT_NAME $docker_tag
  docker push $docker_tag
}

get_master_pod_name() {
  pod_list=$(oc get pods -l app=conjur-node --no-headers | awk '{ print $1 }')
  echo $pod_list | awk '{print $1}'
}

run_conjur_cmd_as_admin() {
  local command=$(cat $@)

  conjur authn logout > /dev/null
  conjur authn login -u admin -p "$CONJUR_ADMIN_PASSWORD" > /dev/null

  local output=$(eval "$command")

  conjur authn logout > /dev/null
  echo "$output"
}

set_project() {
  # general utility for switching projects/namespaces/contexts in openshift
  # expects exactly 1 argument, a project name.
  if [[ $# != 1 ]]; then
    printf "Error in %s/%s - expecting 1 arg.\n" $(pwd) $0
    exit -1
  fi

  oc project $1 > /dev/null
}

load_policy() {
  local POLICY_FILE=$1

  run_conjur_cmd_as_admin <<CMD
conjur policy load --as-group security_admin "policy/$POLICY_FILE"
CMD
}

rotate_host_api_key() {
  local host=$1

  run_conjur_cmd_as_admin <<CMD
conjur host rotate_api_key -h $host
CMD
}
