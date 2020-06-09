#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
WEBAPI_PATH="$DIR/../webapi"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity $AWS_PROFILE --query Account)"
AWS_ACCOUNT_ID="$(echo $AWS_ACCOUNT_ID | sed 's/"//g')"

echo -------------Variables
echo PROJECT_NAME        $PROJECT_NAME
echo AWS_PROFILE         $AWS_PROFILE
echo DIR                 $DIR
echo WEBAPI_PATH         $WEBAPI_PATH
echo AWS_REGION          $AWS_REGION
echo AWS_ACCOUNT_ID      $AWS_ACCOUNT_ID
echo
echo

echo ------------- Building webapi
cd ${WEBAPI_PATH} && \
echo docker build . -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
docker build . -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest

echo ------------- Check
echo docker run -p 8080:8080 --detach $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
echo In browser http://192.168.99.100:8080/api/mysfits
