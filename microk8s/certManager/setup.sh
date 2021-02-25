#!/bin/bash

TYPE=${1-local}

SCRIPT_PATH=$(dirname $0)
kubectl create namespace cert-manager 2>/dev/null

if [ 'local' == "${TYPE}" ]; then
    rm -rf tmp
    mkdir tmp
    # Generate a CA private key
    openssl genrsa -out tmp/ca.key 2048
    # Create a self signed Certificate, valid for 10yrs with the 'signing' option set
    openssl req -x509 -new -nodes -key tmp/ca.key -subj "/CN=localk8s" -days 3650 -reqexts v3_req -extensions v3_ca -out tmp/ca.crt

    kubectl create secret tls ca-key-pair \
        --cert=tmp/ca.crt \
        --key=tmp/ca.key \
        --namespace=cert-manager
fi

helm repo add jetstack https://charts.jetstack.io
helm repo update

helm upgrade --install \
    --create-namespace \
    -n cert-manager \
    -f "${SCRIPT_PATH}/values.yaml" \
    cert-manager \
    jetstack/cert-manager \
    --wait

kubectl apply -f "${SCRIPT_PATH}/${TYPE}.yaml"
