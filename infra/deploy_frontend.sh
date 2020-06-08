#!/usr/bin/env bash
PROJECT_NAME="sam-estepa-sl-dev"
AWS_PROFILE="--profile samsoftware-estepa"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
FRONTEND_PATH="$DIR/../frontend"
FRONTEND_BUILD_PATH="$DIR/../frontend/dist"
AWS_REGION="$(aws configure get region $AWS_PROFILE)"
if [ -z "$AWS_REGION" ]; then
    AWS_REGION="eu-west-1";
fi
S3_BUCKET_NAME="$PROJECT_NAME-frontend-$(aws sts get-caller-identity --query Account --output text $AWS_PROFILE)"

cd ${FRONTEND_PATH} && \

echo -------------Variables:
echo PROJECT_NAME        $PROJECT_NAME
echo AWS_PROFILE         $AWS_PROFILE
echo DIR                 $DIR
echo FRONTEND_PATH       $FRONTEND_PATH
echo FRONTEND_BUILD_PATH $FRONTEND_BUILD_PATH
echo AWS_REGION          $AWS_REGION
echo S3_BUCKET_NAME      $S3_BUCKET_NAME

echo ------------- Building frontend:
# # npm run build -- --prod
node_modules/@angular/cli/bin/ng build --prod

echo ------------- Creation and Copying to bucket:
aws s3 $AWS_PROFILE mb s3://$S3_BUCKET_NAME --region $AWS_REGION || true
aws s3 $AWS_PROFILE website s3://$S3_BUCKET_NAME --index index.html --error index.html
aws s3 $AWS_PROFILE rm s3://$S3_BUCKET_NAME --recursive
aws s3 $AWS_PROFILE cp $FRONTEND_BUILD_PATH s3://$S3_BUCKET_NAME --acl public-read --recursive
S3_BUCKET_LOCATION=$(aws s3api $AWS_PROFILE get-bucket-location --bucket $S3_BUCKET_NAME --query LocationConstraint --output text)

echo ------------- Output:
echo S3_BUCKET_LOCATION      $S3_BUCKET_LOCATION
if [ ! $S3_BUCKET_LOCATION = "None" ]; then
    echo "View your project here: http://$S3_BUCKET_NAME.s3-website.$S3_BUCKET_LOCATION.amazonaws.com"
else
    echo "View your project here: http://$S3_BUCKET_NAME.s3-website.us-east-1.amazonaws.com"
fi