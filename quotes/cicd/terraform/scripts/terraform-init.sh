#!/bin/sh

HELP="This is a script for initializing terraform folders with remote state in s3.
Usage: $0 [-f TERRAFORM_FOLDER] <-n APPLICATION_NAME> <-l LIFECYCLE> [-h]

Required:
    -n APPLICATION_NAME
    -l LIFECYCLE

Optional:
    -f TERRAFORM_FOLDER ('.' by default)
    -r AWS_REGION ('us-east-1' by default)"

usage() { echo "${HELP}" 1>&2; exit 1; }

TERRAFORM_FOLDER='.'
AWS_REGION='us-east-1'

while getopts "f:n:l:r:h" arg; do
  case $arg in
    f)
      TERRAFORM_FOLDER=$OPTARG
      ;;
    n)
      APPLICATION_NAME=$OPTARG
      ;;
    l)
      LIFECYCLE=$OPTARG
      ;;
    r)
      AWS_REGION=$OPTARG
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

if [ -z ${APPLICATION_NAME} ] || [ -z ${LIFECYCLE} ]; then
    echo "Missing required arguements"
    usage
fi

AWS_ACCOUNT_ID=$(aws sts get-caller-identity --output text --query 'Account')

if [ $? != 0 ]; then
    echo "Could not retrieve aws account information"
    exit 1
fi

S3_BUCKET_NAME="terraform-state-${AWS_REGION}-${AWS_ACCOUNT_ID}"
S3_BUCKET_KEY="${APPLICATION_NAME}/${LIFECYCLE}"

aws s3api create-bucket --bucket ${S3_BUCKET_NAME} --acl private --region ${AWS_REGION}

if [ $? != 0 ]; then
    echo "Failed to create s3 backend bucket: ${S3_BUCKET_NAME}"
    exit 1
fi

# cd to terraform folder
cd ${TERRAFORM_FOLDER}

# Clear any existing terraform config files
rm -rf .terraform

terraform init \
    -backend-config="bucket=${S3_BUCKET_NAME}" \
    -backend-config="key=${S3_BUCKET_KEY}" \
    -backend-config="region=${AWS_REGION}"
