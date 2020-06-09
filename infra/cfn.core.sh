#!/usr/bin/env bash
source variables.sh
echo ------------- create-stack $CFN_STACK_NAME
set -x;
aws cloudformation create-stack $AWS_PROFILE --stack-name $CFN_STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body file://cfn.core.yml
set +x;
echo
echo ------------- Check
echo after finish you can check creation state with
echo aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME --query Stacks[0].StackStatus
echo To delete-stack
echo aws cloudformation $AWS_PROFILE delete-stack --stack-name $CFN_STACK_NAME
echo
echo ------------- Save Stack Description
echo "aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME > result.cfn.core.$CFN_STACK_NAME.json"
echo