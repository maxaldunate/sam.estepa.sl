#!/usr/bin/env bash
source variables.sh

results() {
    echo "{" > ../results/fix_resources.json
    echo "   ECRRepositoryName: '$ECR_REPOSITORY'," >> ../results/fix_resources.json
    echo "   FrontendBucketUrl: 'http://$S3_FRONTEND_BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com'" >> ../results/fix_resources.json
    echo "}" >> ../results/fix_resources.json
    echo
}

aws_registry_create() {
    echo $LINE AWS Registry Create
    set -x;
    aws ecr $AWS_PROFILE create-repository --repository-name $ECR_REPOSITORY
    set +x;
    echo
}
aws_registry_destroy() {
    echo $LINE AWS Registry Destroy
    set -x;
    aws ecr $AWS_PROFILE delete-repository --repository-name $ECR_REPOSITORY --force
    set +x;
    echo
}

frontend_bucket_create() {
    echo $LINE Creation Frontend Bucket
    set -x;
    aws s3 $AWS_PROFILE mb s3://$S3_FRONTEND_BUCKET_NAME --region $AWS_REGION || true
    aws s3 $AWS_PROFILE website s3://$S3_FRONTEND_BUCKET_NAME --index index.html --error index.html
    set +x;
}
frontend_bucket_destroy() {
    echo $LINE Delete frontend bucket
    set -x;
    aws s3 $AWS_PROFILE rb s3://$S3_FRONTEND_BUCKET_NAME --force
    set +x;
}

create() {
    aws_registry_create
    frontend_bucket_create
    results
}

destroy() {
    aws_registry_destroy
    frontend_bucket_destroy
}

USAGGE="Error! Usage : './fix_resources.sh create' or './fix_resources.sh destroy'"
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