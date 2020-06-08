#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"

STACK_NAME=$PROJECT_NAME-CoreStack

echo -------------Variables
echo PROJECT_NAME        $PROJECT_NAME
echo AWS_PROFILE         $AWS_PROFILE
echo AWS_REGION          $AWS_REGION
echo STACK_NAME          $STACK_NAME
echo
echo ------------- create-stack $STACK_NAME
#echo aws cloudformation create-stack $AWS_PROFILE --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body file://core.yml
aws cloudformation create-stack $AWS_PROFILE --stack-name $STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body file://core.yml
echo
echo ------------- Check
echo after finish you can check creation state with
echo aws cloudformation $AWS_PROFILE describe-stacks --stack-name $STACK_NAME
echo