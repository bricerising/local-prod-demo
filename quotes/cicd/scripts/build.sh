#!/bin/sh

eval "$(cat cicd/settings.sh)"

VERSION=${1-$(date +%s)}

docker build -t ${APPLICATION_NAME}:${VERSION} -t ${APPLICATION_NAME}:latest .
