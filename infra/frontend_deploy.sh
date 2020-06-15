#!/usr/bin/env bash
source variables.sh
echo ------------- Building frontend
cd ${FRONTEND_PATH} && \
# # npm run build -- --prod
node_modules/@angular/cli/bin/ng build --prod
echo
echo ------------- Creation and Copying to bucket
aws s3 $AWS_PROFILE rm s3://$S3_FRONTEND_BUCKET_NAME --recursive
aws s3 $AWS_PROFILE cp $FRONTEND_BUILD_PATH s3://$S3_FRONTEND_BUCKET_NAME --acl public-read --recursive
echo
echo ------------- Output:
echo "View your project here: http://$S3_FRONTEND_BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com"
echo "View your project here: http://$S3_FRONTEND_BUCKET_NAME.s3-website-$AWS_REGION.amazonaws.com" > $CURRENT_DIR/result.frontend_deploy.json
echo
echo ------------- Check:
set -x;
aws s3api $AWS_PROFILE wait bucket-exists --bucket $S3_FRONTEND_BUCKET_NAME
set +x;
