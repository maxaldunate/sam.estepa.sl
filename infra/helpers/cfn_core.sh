#!/usr/bin/env bash
source variables.sh

results() {
    echo $LINE Save Stack Description
    set -x;
    aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME > ../results/cfn_core.json
    set +x;
    echo
}

check() {
    echo $LINE Check Status of creation
    echo after finish you MUST run 'cfn_core_results.sh'
    set -x;
    aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME --query Stacks[0].StackStatus
    set +x;
}

stack_create() {
    echo $LINE create-stack $CFN_STACK_NAME
    set -x;
    aws cloudformation $AWS_PROFILE create-stack --stack-name $CFN_STACK_NAME --capabilities CAPABILITY_NAMED_IAM --template-body file://cfn_core.yml
    set +x;
    echo
}
stack_destroy() {
    echo $LINE destroy-stack $CFN_STACK_NAME
    set -x;
    aws cloudformation $AWS_PROFILE delete-stack --stack-name $CFN_STACK_NAME
    set +x;
    echo
}

create() {
    stack_create

    STACK_STATUS=$(aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME --query Stacks[0].StackStatus --output text)
    until [ $STACK_STATUS == "CREATE_COMPLETE" ]; do
        sleep 30
        STACK_STATUS=$(aws cloudformation $AWS_PROFILE describe-stacks --stack-name $CFN_STACK_NAME --query Stacks[0].StackStatus --output text)
        echo Current status ... $STACK_STATUS
    done
    echo Current status ... $STACK_STATUS

    results
    check
}

destroy() {
    stack_destroy
}

USAGGE="Error! Usage : './cfn_core.sh create' or './cfn_core.sh destroy' "
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