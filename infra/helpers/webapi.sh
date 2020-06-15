#!/usr/bin/env bash
source variables.sh

FARGATE_CONTAINER_SECURITY_GROUP=""
PRIVATE_SUBNET_ONE=""
PRIVATE_SUBNET_TWO=""
PUBLIC_SUBNET_ONE=""
PUBLIC_SUBNET_TWO=""
NLB_TARGET_GROUP_ARN=""

results() {
    echo "{" > ../results/webapi.json
    echo "   \"FARGATE_CONTAINER_SECURITY_GROUP\": \"$FARGATE_CONTAINER_SECURITY_GROUP\"," >> ../results/webapi.json
    echo "   \"ECSClusterName\": \"$PROJECT_NAME-Cluster\"," >> ../results/webapi.json
    echo "   \"CloudWatchLogsGroup\": \"$PROJECT_NAME-logs\"," >> ../results/webapi.json
    echo "   \"PRIVATE_SUBNET_ONE\": \"$PRIVATE_SUBNET_ONE\"," >> ../results/webapi.json
    echo "   \"PRIVATE_SUBNET_TWO\": \"$PRIVATE_SUBNET_TWO\"," >> ../results/webapi.json
    echo "   \"PUBLIC_SUBNET_ONE\": \"$PUBLIC_SUBNET_ONE\"," >> ../results/webapi.json
    echo "   \"PUBLIC_SUBNET_TWO\": \"$PUBLIC_SUBNET_TWO\"," >> ../results/webapi.json
    echo "   \"NLB_TARGET_GROUP_ARN\": \"$NLB_TARGET_GROUP_ARN\"" >> ../results/webapi.json
    echo "}" >> ../results/webapi.json
    echo
}

load_balancer_group_create() {

AQUI ME QUEDO

    echo $LINE Create a Load Balancer Target Group
    aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id "vpc-02b977cd42aaaf7e2" --health-check-interval-seconds 10 --health-check-path "//" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > result-target-group.json
    echo

}

load_balancer_create() {
    echo $LINE Create Network Load Balancer - NLB
    PUBLIC_SUBNET_ONE=$(grep -A2 PublicSubnetOne ../results/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    PUBLIC_SUBNET_TWO=$(grep -A2 PublicSubnetTwo ../results/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    set -x;
    aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets $PUBLIC_SUBNET_ONE $PUBLIC_SUBNET_TWO > ../results/webapi_load_balancer.json
    set +x;
    echo
}
load_balancer_destroy() {
    echo $LINE Destroy Network Load Balancer - NLB
    set -x;
    aws elbv2 $AWS_PROFILE delete-load-balancer --load-balancer-name $PROJECT_NAME-nlb
    set +x;
    echo
}

register_ecs_task_definition_create() {
    echo ------------- Register an ECS Task Definition

    cp task-definition.to.replace.json task-definition.json
    sed -i "s/REPLACE_ME_PROJECT_NAME/$PROJECT_NAME/g" task-definition.json

    FARGATE_CONTAINER_SECURITY_GROUP=$(grep -A2 FargateContainerSecurityGroup ../results/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    sed -i "s/REPLACE_ME_SG_ID/$FARGATE_CONTAINER_SECURITY_GROUP/g" task-definition.json

    PRIVATE_SUBNET_ONE=$(grep -A2 PrivateSubnetOne ../results/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    sed -i "s/REPLACE_ME_PRIVATE_SUBNET_ONE/$PRIVATE_SUBNET_ONE/g" task-definition.json

    PRIVATE_SUBNET_TWO=$(grep -A2 PrivateSubnetTwo ../results/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    sed -i "s/REPLACE_ME_PRIVATE_SUBNET_TWO/$PRIVATE_SUBNET_TWO/g" task-definition.json

    NLB_TARGET_GROUP_ARN=$(grep -A2 LoadBalancerArn ../results/webapi_load_balancer.json | grep LoadBalancerArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    sed -i "s,REPLACE_ME_NLB_TARGET_GROUP_ARN,$NLB_TARGET_GROUP_ARN,g" task-definition.json

    set -x;
    aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json
    set +x;
    echo
}
register_ecs_task_definition_destroy() {
    echo ------------- Deregister an ECS Task Definition
    set -x;
    aws ecs $AWS_PROFILE deregister-task-definition --task-definition The family and revision (family:revision ) or full Amazon Resource Name (ARN) of the task definition to deregister. You must specify a revision .
    set +x;
    echo
}

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
    load_balancer_create
    register_ecs_task_definition_create
    results
}

destroy() {
    register_ecs_task_definition_destroy
    load_balancer_destroy
    cloudwatch_logs_group_destroy
    ecs_cluster_destroy
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