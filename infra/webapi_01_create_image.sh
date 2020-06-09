#!/usr/bin/env bash
source variables.sh

echo ------------- Building webapi
cd ${WEBAPI_PATH} && \
echo docker build . -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
docker build . -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest

echo ------------- Check
echo docker run -p 8080:8080 --detach $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest
echo In browser http://192.168.99.100:8080/api/mysfits
