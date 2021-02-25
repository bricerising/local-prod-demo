#!/bin/bash
set +e

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

eksctl create cluster -f "${SCRIPTPATH}"/cluster.yaml
eksctl utils associate-iam-oidc-provider -f "${SCRIPTPATH}"/cluster.yaml --approve
eksctl create iamserviceaccount -f "${SCRIPTPATH}"/cluster.yaml --override-existing-serviceaccounts --approve
