#!/usr/bin/env bash
source helpers/variables.sh

build_frontend() {	
    echo $LINE Building frontend	
    cd ${FRONTEND_PATH} && \
    # # npm run build -- --prod
    set -x;	
    node_modules/@angular/cli/bin/ng build --prod
    set +x;	
    echo
}

copy_to_bucket() {	
    echo $LINE Copying to bucket	
    set -x;	
    aws s3 $AWS_PROFILE rm s3://$S3_FRONTEND_BUCKET_NAME --recursive
    aws s3 $AWS_PROFILE cp $FRONTEND_BUILD_PATH s3://$S3_FRONTEND_BUCKET_NAME --acl public-read --recursive
    set +x;	
    echo
}

outputs() {
    echo "{" > outputs/frontend_deploy.json
    echo "   \"ProjectDns\": \"http://$S3_FRONTEND_BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com\"" >> outputs/frontend_deploy.json
    echo "}" >> outputs/frontend_deploy.json
    echo
    echo $LINE Check
    set -x;
    aws s3api $AWS_PROFILE wait bucket-exists --bucket $S3_FRONTEND_BUCKET_NAME
    set +x;
    echo ProjectDns http://$S3_FRONTEND_BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com
}

local_variables() {
    echo $LINE Local Variables
    FRONTEND_PATH="$CURRENT_DIR/../../frontend"
    echo -e FRONTEND_PATH '\t' '\t''\t' '\t' $FRONTEND_PATH
    FRONTEND_BUILD_PATH="$CURRENT_DIR/../../frontend/dist"
    echo -e FRONTEND_BUILD_PATH '\t' '\t''\t' $FRONTEND_BUILD_PATH
    echo
}

local_variables
cd ${FRONTEND_PATH} && \
build_frontend
copy_to_bucket
set -x;
cd $CURRENT_DIR/..
set +x;
outputs