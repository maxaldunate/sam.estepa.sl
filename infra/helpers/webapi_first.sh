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

create() {
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