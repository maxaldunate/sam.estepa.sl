#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"
AWS_ACCOUNT_ID="$(aws sts get-caller-identity $AWS_PROFILE --query Account)"
AWS_ACCOUNT_ID="$(echo $AWS_ACCOUNT_ID | sed 's/"//g')"

echo -------------Variables
echo PROJECT_NAME        $PROJECT_NAME
echo AWS_PROFILE         $AWS_PROFILE
echo AWS_REGION          $AWS_REGION
echo AWS_ACCOUNT_ID      $AWS_ACCOUNT_ID
echo
# echo ------------- Create Amazon ECS Cluster
# echo aws ecs $AWS_PROFILE create-cluster --cluster-name $PROJECT_NAME-Cluster
# aws ecs $AWS_PROFILE create-cluster --cluster-name $PROJECT_NAME-Cluster
# echo
# echo ------------- Create CloudWatch Logs Group
# echo aws logs $AWS_PROFILE create-log-group --log-group-name $PROJECT_NAME-logs
# aws logs $AWS_PROFILE create-log-group --log-group-name $PROJECT_NAME-logs
# echo
# echo ------------- Register an ECS Task Definition
# echo aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json
# aws ecs $AWS_PROFILE register-task-definition --cli-input-json file://task-definition.json
# echo
# echo ------------- Network Load Balancer - NLB
# echo "aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets subnet-057bf70568ce1086f subnet-049a98be0cfaa7199 > result-dns,json"
# aws elbv2 $AWS_PROFILE create-load-balancer --name $PROJECT_NAME-nlb --scheme internet-facing --type network --subnets subnet-057bf70568ce1086f subnet-049a98be0cfaa7199 > result-dns,json
# echo
# echo ------------- Create a Load Balancer Target Group
# echo "aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id \"vpc-02b977cd42aaaf7e2\" --health-check-interval-seconds 10 --health-check-path \"//\" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > result-target-group.json"
# aws elbv2 $AWS_PROFILE create-target-group --name $PROJECT_NAME-TargetGroup --port 8080 --protocol TCP --target-type ip --vpc-id "vpc-02b977cd42aaaf7e2" --health-check-interval-seconds 10 --health-check-path "//" --health-check-protocol HTTP --healthy-threshold-count 3 --unhealthy-threshold-count 3 > result-target-group.json
echo
echo ------------- Create a Load Balancer Listener





# echo ------------- Check
# echo aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi
# aws ecr $AWS_PROFILE describe-images --repository-name sam-estepa-sl/service-webapi