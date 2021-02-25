#!/bin/bash

SCRIPT_PATH=$(dirname $0)
helm upgrade --install --create-namespace dynamodb -n local "${SCRIPT_PATH}"/chart
