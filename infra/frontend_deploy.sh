#!/usr/bin/env bash
source variables.sh
echo ------------- Building frontend
cd ${FRONTEND_PATH} && \
# # npm run build -- --prod
node_modules/@angular/cli/bin/ng build --prod
echo
echo ------------- Creation and Copying to bucket
aws s3 $AWS_PROFILE website s3://$S3_FRONTEND_BUCKET_NAME --index index.html --error index.html
aws s3 $AWS_PROFILE rm s3://$S3_FRONTEND_BUCKET_NAME --recursive
aws s3 $AWS_PROFILE cp $FRONTEND_BUILD_PATH s3://$S3_FRONTEND_BUCKET_NAME --acl public-read --recursive
S3_BUCKET_LOCATION=$(aws s3api $AWS_PROFILE get-bucket-location --bucket $S3_FRONTEND_BUCKET_NAME --query LocationConstraint --output text)
echo
echo ------------- Output:
echo S3_BUCKET_LOCATION      $S3_BUCKET_LOCATION
echo "View your project here: http://$S3_FRONTEND_BUCKET_NAME.s3-website.$S3_BUCKET_LOCATION.amazonaws.com"
echo "View your project here: http://$S3_FRONTEND_BUCKET_NAME.s3-website.$S3_BUCKET_LOCATION.amazonaws.com" > $CURRENT_DIR/result.frontend_deploy.json
echo
echo ------------- Check:
set -x;
aws s3api $AWS_PROFILE wait bucket-exists --bucket $S3_FRONTEND_BUCKET_NAME
set +x;
