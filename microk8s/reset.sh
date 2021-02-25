#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

"${SCRIPTPATH}/unsetup.sh"
"${SCRIPTPATH}/setup.sh"
