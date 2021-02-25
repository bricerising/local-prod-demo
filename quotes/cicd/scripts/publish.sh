#!/bin/sh

eval "$(cat cicd/settings.sh)"

HELP="This script is for publishing artifacts of this project to ecr.
Usage: $0 <-v VERSION> <-l LIFECYCLE> [-h]

Required:
    -v VERSION
    -l LIFECYCLE"

usage() { echo "${HELP}" 1>&2; exit 1; }

AWS_REGION='us-east-1'

while getopts "v:l:r:h" arg; do
  case $arg in
    v)
      VERSION=$OPTARG
      ;;
    l)
      LIFECYCLE=$OPTARG
      ;;
    h)
      echo "${HELP}"
      exit 0
      ;;
    *)
      usage
      ;;
  esac
done

if [ -z ${VERSION} ] || [ -z ${LIFECYCLE} ]; then
    echo "Missing required arguements"
    usage
fi

REPOSITORY_URL=localhost:32000/${APPLICATION_NAME}

if [ 'local' != "${LIFECYCLE}" ]; then
    aws ecr create-repository --region ${AWS_REGION} --repository-name ${APPLICATION_NAME}/${LIFECYCLE} 2> /dev/null
    REPOSITORY_URL=$(aws ecr describe-repositories --region ${AWS_REGION} --repository-name ${APPLICATION_NAME}/${LIFECYCLE} | jq -r '.repositories[0].repositoryUri')
    $(aws ecr get-login --no-include-email --region us-east-1)
fi

docker tag ${APPLICATION_NAME}:${VERSION} ${REPOSITORY_URL}:${VERSION}
docker tag ${APPLICATION_NAME}:${VERSION} ${REPOSITORY_URL}:latest

docker push ${REPOSITORY_URL}:${VERSION}
docker push ${REPOSITORY_URL}:latest
