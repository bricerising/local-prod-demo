#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

eksctl create cluster -f "${SCRIPTPATH}"/cluster.yaml
#eksctl create nodegroup -f "${SCRIPTPATH}"/cluster.yaml
#eksctl create cluster -f "${SCRIPTPATH}"/cluster.yaml
