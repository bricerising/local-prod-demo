#!/bin/bash

microk8s helm3 delete -n cert-manager cert-manager
kubectl delete -n local

microk8s reset
