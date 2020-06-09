#!/usr/bin/env bash
source variables.sh

echo ------------- creating AWS Registry
echo aws ecr $AWS_PROFILE create-repository --repository-name sam-estepa-sl/service-webapi
aws ecr $AWS_PROFILE create-repository --repository-name sam-estepa-sl/service-webapi
echo
echo ------------- login
echo aws ecr $AWS_PROFILE get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
aws ecr $AWS_PROFILE get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
echo ------------- Push docker image to registry
echo docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
echo
echo ------------- Check
echo aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi
aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi