#!/usr/bin/env bash
source variables.sh

FARGATE_CONTAINER_SECURITY_GROUP=""
PRIVATE_SUBNET_ONE=""
PRIVATE_SUBNET_TWO=""
PUBLIC_SUBNET_ONE=""
PUBLIC_SUBNET_TWO=""

ECS_CLUSTER_ARN=""

NLB_ARN=""
NLB_TARGET_GROUP_ARN=""
NLB_LISTENER_ARN=""
VPC_ID=""

outputs() {
    echo "{" > ../outputs/webapi.json
    echo "   \"ECSClusterName\": \"$PROJECT_NAME-Cluster\"," >> ../outputs/webapi.json
    echo "   \"CloudWatchLogsGroup\": \"$PROJECT_NAME-logs\"," >> ../outputs/webapi.json
    echo "   \"FARGATE_CONTAINER_SECURITY_GROUP\": \"$FARGATE_CONTAINER_SECURITY_GROUP\"," >> ../outputs/webapi.json
    echo "   \"PRIVATE_SUBNET_ONE\": \"$PRIVATE_SUBNET_ONE\"," >> ../outputs/webapi.json
    echo "   \"PRIVATE_SUBNET_TWO\": \"$PRIVATE_SUBNET_TWO\"," >> ../outputs/webapi.json
    echo "   \"PUBLIC_SUBNET_ONE\": \"$PUBLIC_SUBNET_ONE\"," >> ../outputs/webapi.json
    echo "   \"PUBLIC_SUBNET_TWO\": \"$PUBLIC_SUBNET_TWO\"," >> ../outputs/webapi.json
    
    echo "   \"ECS_CLUSTER_ARN\": \"$ECS_CLUSTER_ARN\"," >> ../outputs/webapi.json
    echo "   \"VPC_ID\": \"$VPC_ID\"," >> ../outputs/webapi.json

    echo "   \"NLB_ARN\": \"$NLB_ARN\"," >> ../outputs/webapi.json
    echo "   \"NLB_TARGET_GROUP_ARN\": \"$NLB_TARGET_GROUP_ARN\"," >> ../outputs/webapi.json
    echo "   \"NLB_LISTENER_ARN\": \"$NLB_LISTENER_ARN\"" >> ../outputs/webapi.json
    echo "}" >> ../outputs/webapi.json
    echo
}

get_variables_from_cfn_core() {
    VPC_ID=$(grep -A2 VPCId ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    FARGATE_CONTAINER_SECURITY_GROUP=$(grep -A2 FargateContainerSecurityGroup ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    PRIVATE_SUBNET_ONE=$(grep -A2 PrivateSubnetOne ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    PRIVATE_SUBNET_TWO=$(grep -A2 PrivateSubnetTwo ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    PUBLIC_SUBNET_ONE=$(grep -A2 PublicSubnetOne ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    PUBLIC_SUBNET_TWO=$(grep -A2 PublicSubnetTwo ../outputs/cfn_core.json | grep OutputValue | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
}

load_balancer_create() {
    echo $LINE Create NLB
    set -x;
    aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets $PUBLIC_SUBNET_ONE $PUBLIC_SUBNET_TWO > ../outputs/webapi_nlb.json
    set +x;
    NLB_ARN=$(grep -A2 LoadBalancerArn ../outputs/webapi_nlb.json | grep LoadBalancerArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)

    echo $LINE Create NLB Target Group
    set -x;
    aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id $VPC_ID --health-check-interval-seconds 10 --health-check-path "//" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > ../outputs/webapi_nlb_target_group.json
    set +x;
    NLB_TARGET_GROUP_ARN=$(grep -A2 TargetGroupArn ../outputs/webapi_nlb_target_group.json | grep TargetGroupArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)

    echo $LINE Create NLB Listener
    set -x;
    aws elbv2 $AWS_PROFILE create-listener --default-actions TargetGroupArn=$NLB_TARGET_GROUP_ARN,Type=forward --load-balancer-arn $NLB_ARN --port 80 --protocol TCP > ../outputs/webapi_nbl_listener.json 
    set +x;
    NLB_LISTENER_ARN=$(grep -A2 ListenerArn ../outputs/webapi_nbl_listener.json | grep ListenerArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)

    
    echo
}
load_balancer_destroy() {
    echo $LINE Destroy NLB Listener
    NLB_LISTENER_ARN=$(grep -A2 ListenerArn ../outputs/webapi_nbl_listener.json | grep ListenerArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    set -x;
    aws elbv2 $AWS_PROFILE delete-listener --listener-arn $NLB_LISTENER_ARN
    set +x;
    echo
    echo $LINE Destroy NLB Target Group
    NLB_TARGET_GROUP_ARN=$(grep -A2 TargetGroupArn ../outputs/webapi_nlb_target_group.json | grep TargetGroupArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    set -x;
    aws elbv2 $AWS_PROFILE delete-target-group --target-group-arn $NLB_TARGET_GROUP_ARN
    set +x;
    echo
    echo $LINE Destroy NLB
    NLB_ARN=$(grep -A2 LoadBalancerArn ../outputs/webapi_nlb.json | grep LoadBalancerArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    set -x;
    aws elbv2 $AWS_PROFILE delete-load-balancer --load-balancer-arn $NLB_ARN
    set +x;
    echo
}

service_definition_create() {
    echo ------------- Create Service Definition

    cp task-definition.to.replace.json task-definition.json

    sed -i "s/REPLACE_ME_PROJECT_NAME/$PROJECT_NAME/g" task-definition.json
    sed -i "s/REPLACE_ME_SG_ID/$FARGATE_CONTAINER_SECURITY_GROUP/g" task-definition.json
    sed -i "s/REPLACE_ME_PRIVATE_SUBNET_ONE/$PRIVATE_SUBNET_ONE/g" task-definition.json
    sed -i "s/REPLACE_ME_PRIVATE_SUBNET_TWO/$PRIVATE_SUBNET_TWO/g" task-definition.json
    sed -i "s,REPLACE_ME_NLB_TARGET_GROUP_ARN,$NLB_TARGET_GROUP_ARN,g" task-definition.json

    set -x;
    aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json > ../outputs/webapi_ecs_task_definition.json
    set +x;
    echo
}

register_ecs_task_definition_create() {
    echo ------------- Register an ECS Task Definition

    cp task-definition.to.replace.json task-definition.json

REEMPLAZAR LOS VALORES QUE TOQUE

    set -x;
    aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json > ../outputs/webapi_ecs_task_definition.json
    set +x;
    echo
}
register_ecs_task_definition_destroy() {
    echo ------------- Deregister an ECS Task Definition
    set -x;
    aws ecs $AWS_PROFILE deregister-task-definition --task-definition 
    # ToDo Max. The family and revision (family:revision ) or full Amazon Resource Name (ARN) of the task definition to deregister. You must specify a revision .
    set +x;
    echo
}

ecs_cluster_create() {
    echo $LINE Create Amazon ECS Cluster
    set -x;
    aws ecs $AWS_PROFILE create-cluster --cluster-name $PROJECT_NAME-Cluster > ../outputs/webapi_ecs_cluster.json 
    set +x;
    ECS_CLUSTER_ARN=$(grep -A2 clusterArn ../outputs/webapi_ecs_cluster.json | grep clusterArn | grep -oP '"\K[^"\047]+(?=["\047])' | tail -1)
    echo
}
ecs_cluster_destroy() {
    echo $LINE Destroy Amazon ECS Cluster
    set -x;
    aws ecs $AWS_PROFILE delete-cluster --cluster $PROJECT_NAME-Cluster > ../outputs/webapi_ecs_cluster.json
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
    get_variables_from_cfn_core
    ecs_cluster_create
    cloudwatch_logs_group_create
    load_balancer_create
    register_ecs_task_definition_create
    outputs
}

destroy() {
    get_variables_from_cfn_core
    #register_ecs_task_definition_destroy
    load_balancer_destroy
    cloudwatch_logs_group_destroy
    ecs_cluster_destroy
    outputs
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