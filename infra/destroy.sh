#!/usr/bin/env bash
source variables.sh
echo ------------- Delete Stack
set -x;
aws cloudformation $AWS_PROFILE delete-stack --stack-name $CFN_STACK_NAME
set +x;
echo
echo ------------- Delete frontend bucket
set -x;
aws s3 $AWS_PROFILE rb s3://$S3_FRONTEND_BUCKET_NAME --force
set +x;
echo





exit 0