#!/usr/bin/env bash
source variables.sh

build_api() {	
    echo $LINE Building webapi	
    cd ../${WEBAPI_PATH} && \	
    set -x;	
    docker build . -t $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest	
    set +x;	
}

run_local_docker_webapi() {	
    echo $LINE Check	
    set -x;	
    docker run -p 8080:8080 --detach $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest	
    set +x;	
    echo In browser http://192.168.99.100:8080/api/mysfits	
}

push_docker_webapi_image() {	
    echo $LINE login	
    set -x;	
    aws ecr $AWS_PROFILE get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com	
    set +x;	
    echo $LINE Push docker image to registry	
    set -x;	
    docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/sam-estepa-sl/service-webapi:latest	
    set +x;	
    echo	
    echo $LINE Check	
    set -x;	
    aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi	
    set +x;	
}

build_api	
run_local_docker_webapi	
push_docker_webapi_image