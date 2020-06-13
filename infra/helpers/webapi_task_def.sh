#!/usr/bin/env bash
source variables.sh


echo ------------- Create a Load Balancer Listener

AQUI ME QUEDO


echo ------------- Register an ECS Task Definition
echo aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json
aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json
echo

echo ------------- Network Load Balancer - NLB
echo "aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets subnet-057bf70568ce1086f subnet-049a98be0cfaa7199 > result-dns,json"
aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets subnet-057bf70568ce1086f subnet-049a98be0cfaa7199 > result-dns,json
echo
echo ------------- Create a Load Balancer Target Group
echo "aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id \"vpc-02b977cd42aaaf7e2\" --health-check-interval-seconds 10 --health-check-path \"//\" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > result-target-group.json"
aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id "vpc-02b977cd42aaaf7e2" --health-check-interval-seconds 10 --health-check-path "//" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > result-target-group.json
echo




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


create() {
}

destroy() {
}

USAGGE="Error! Usage : './webapi_task_def.sh create' or './webapi_task_def.sh destroy'"
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