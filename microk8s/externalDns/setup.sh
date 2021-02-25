#!/bin/bash

SCRIPT_PATH=$(dirname $0)

helm repo add bitnami https://charts.bitnami.com/bitnami

helm upgrade --install \
    -n kube-system \
    -f "${SCRIPT_PATH}/values.yaml" \
    external-dns \
    bitnami/external-dns \
    --set aws.credentials.accessKey="${AWS_ACCESS_KEY_ID}" \
    --set aws.credentials.secretKey="${AWS_SECRET_ACCESS_KEY}" \
    --set aws.region="${AWS_DEFAULT_REGION}" \
    --wait
