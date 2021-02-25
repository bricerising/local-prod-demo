#!/bin/bash

microk8s status --wait-ready
microk8s enable dashboard dns registry metrics-server helm3 fluentd metallb
