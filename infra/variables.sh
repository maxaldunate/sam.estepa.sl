#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity $AWS_PROFILE --query Account --output text)"
# --
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FRONTEND_PATH="$DIR../frontend"
FRONTEND_BUILD_PATH="$DIR../frontend/dist"
WEBAPI_PATH="$DIR../webapi"
# --
S3_FRONTEND_BUCKET_NAME=$PROJECT_NAME-frontend-$AWS_ACCOUNT_ID
CFN_STACK_NAME=$PROJECT_NAME-CoreStack
echo
echo -------------Variables
echo -e PROJECT_NAME '\t' '\t''\t' '\t' $PROJECT_NAME
echo -e AWS_PROFILE '\t' '\t''\t' '\t' $AWS_PROFILE
echo -e AWS_REGION '\t' '\t''\t' '\t' $AWS_REGION
echo -e AWS_ACCOUNT_ID '\t' '\t''\t' '\t' $AWS_ACCOUNT_ID
echo -e CURRENT_DIR '\t' '\t''\t' '\t' $CURRENT_DIR
echo -e FRONTEND_PATH '\t' '\t''\t' '\t' $FRONTEND_PATH
echo -e FRONTEND_BUILD_PATH  '\t''\t' '\t' $FRONTEND_BUILD_PATH
echo -e WEBAPI_PATH '\t''\t' '\t''\t' $WEBAPI_PATH
echo -e S3_FRONTEND_BUCKET_NAME '\t''\t' $S3_FRONTEND_BUCKET_NAME
echo -e CFN_STACK_NAME '\t' '\t''\t''\t' $CFN_STACK_NAME
echo
