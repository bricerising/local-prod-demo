#!/bin/bash
set -e

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
LIFECYCLE="${1-local}"

if [ 'local' == "${LIFECYCLE}" ]; then
    "${SCRIPTPATH}"/microk8s/setup.sh
elif [ 'dev' == "${LIFECYCLE}" ]; then
    "${SCRIPTPATH}"/eks/setup.sh
fi

#"${SCRIPTPATH}"/certManager/setup.sh "${LIFECYCLE}"
"${SCRIPTPATH}"/externalDns/setup.sh
"${SCRIPTPATH}"/kong/setup.sh

if [ 'local' == "${LIFECYCLE}" ]; then
    "${SCRIPTPATH}"/dynamodb/setup.sh
fi
