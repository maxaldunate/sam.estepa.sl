#!/usr/bin/env bash
source variables.sh

ecs_cluster_create() {
    echo $LINE Create Amazon ECS Cluster
    set -x;
    aws ecs $AWS_PROFILE create-cluster --cluster-name $PROJECT_NAME-Cluster
    set +x;
    echo
}
ecs_cluster_destroy() {
    echo $LINE Destroy Amazon ECS Cluster
    set -x;
    aws ecs $AWS_PROFILE delete-cluster --cluster $PROJECT_NAME-Cluster
    set +x;
    echo
}

cloudwatch_logs_group_create() {
    echo $LINE Create CloudWatch Logs Group
    set -x;
    aws logs $AWS_PROFILE create-log-group --log-group-name $PROJECT_NAME-logs
    set +x;
    echo
}
cloudwatch_logs_group_destroy() {
    echo $LINE Destroy CloudWatch Logs Group
    set -x;
    aws logs $AWS_PROFILE delete-log-group --log-group-name $PROJECT_NAME-logs

    set +x;
    echo
}

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

create() {
    build_api
    run_local_docker_webapi
    push_docker_webapi_image

    ecs_cluster_create
    cloudwatch_logs_group_create

}

destroy() {
    ecs_cluster_destroy
    cloudwatch_logs_group_destroy
}

USAGGE="Error! Usage : './webapi_first.sh create' or './webapi_first.sh destroy'"
if [ -z $1 ]
then
    echo $USAGGE & exit 1
else
    if [ $1 != "create" ] && [ $1 != "destroy" ]
    then
        echo $USAGGE & exit 1
    fi
    if [ $1 == "create" ]
    then
        create
    else
        destroy
    fi
fi