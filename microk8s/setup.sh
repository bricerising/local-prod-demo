#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

microk8s status --wait-ready
microk8s enable dashboard dns registry metrics-server helm3 fluentd metallb

"${SCRIPTPATH}"/certManager/setup.sh
"${SCRIPTPATH}"/externalDns/setup.sh
"${SCRIPTPATH}"/kong/setup.sh
"${SCRIPTPATH}"/dynamodb/setup.sh
