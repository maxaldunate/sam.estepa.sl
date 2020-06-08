#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity $AWS_PROFILE --query Account)"
AWS_ACCOUNT_ID="$(echo $AWS_ACCOUNT_ID | sed 's/"//g')"
AUTH_TOKEN="$(aws ecr get-authorization-token $AWS_PROFILE --query authorizationData[0].authorizationToken)"

echo -------------Variables
echo PROJECT_NAME        $PROJECT_NAME
echo AWS_PROFILE         $AWS_PROFILE
echo AWS_REGION          $AWS_REGION
echo AWS_ACCOUNT_ID      $AWS_ACCOUNT_ID
echo AUTH_TOKEN          $AUTH_TOKEN
echo
echo ------------- createing AWS Registry
echo aws ecr $AWS_PROFILE create-repository --repository-name sam-estepa-sl/service-webapi
aws ecr $AWS_PROFILE create-repository --repository-name sam-estepa-sl/service-webapi
echo
echo ------------- login
echo aws ecr get-authorization-token $AWS_PROFILE --query authorizationData[0].authorizationToken 
echo
echo ------------- Push docker image to registry
echo docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
echo
echo ------------- Check
echo aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi
aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi