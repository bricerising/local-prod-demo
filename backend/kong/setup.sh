#!/bin/bash

SCRIPT_PATH=$(dirname $0)

helm repo add kong https://charts.konghq.com
helm repo update

kubectl create namespace kong 2>/dev/null || true

helm upgrade --install -n kong kong kong/kong -f "${SCRIPT_PATH}/values.yaml"
