#!/bin/bash

eval "$(cat cicd/settings.sh)"

HELP="This script applies terraform state for a specific application lifecycle.
Usage: $0 <-l LIFECYCLE> <-r application|database> [-v APPLICATION_VERSION] [-h] [-f]

Required:
    -r RESOURCE
    -l LIFECYCLE

Optional:
    -v APPLICATION_VERSION
    -f"

usage() { echo "${HELP}" 1>&2; exit 1; }

AWS_REGION='us-east-1'
APPLICATION_VERSION='latest'
TERRAFORM_AUTO_APPROVE=''

SCRIPT_PATH=$(dirname $0)

while getopts "l:r:v:fh" arg; do
  case $arg in
    l)
      LIFECYCLE=$OPTARG
      ;;
    r)
      RESOURCE=$OPTARG
      ;;
    v)
      APPLICATION_VERSION=$OPTARG
      ;;
    f)
      TERRAFORM_AUTO_APPROVE='-auto-approve'
      ;;
    h)
      echo "${HELP}"
      exit 0
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z ${LIFECYCLE} ] || [ -z ${RESOURCE} ]; then
    echo "Missing required arguments"
    usage
fi

if [ "${RESOURCE}" == "application" ]; then
  helm upgrade --install \
    -n "${LIFECYCLE}" \
    --set deployment.version="${APPLICATION_VERSION}" \
    --set deployment.env.LIFECYCLE="${LIFECYCLE}" \
    "${APPLICATION_NAME}" "${SCRIPT_PATH}/../chart"
else
  cicd/terraform/scripts/terraform-init.sh -n ${APPLICATION_NAME}/${RESOURCE}  -l ${LIFECYCLE} -f cicd/terraform/${RESOURCE}

  cd cicd/terraform/${RESOURCE}

  if [ "${LIFECYCLE}" == 'local' ]; then
    export AWS_ACCESS_KEY_ID=local
    export AWS_SECRET_ACCESS_KEY=local
    export AWS_DEFAULT_REGION=us-east-1
  fi

  if grep application_version vars.tf; then
    terraform apply \
        --var-file ../tfvars/${LIFECYCLE}.tfvars \
        --var application_name=${APPLICATION_NAME} \
        --var application_version=${APPLICATION_VERSION} \
        ${TERRAFORM_AUTO_APPROVE}
  else
    terraform apply \
        --var-file ../tfvars/${LIFECYCLE}.tfvars \
        --var application_name=${APPLICATION_NAME} \
        ${TERRAFORM_AUTO_APPROVE}
  fi
fi
