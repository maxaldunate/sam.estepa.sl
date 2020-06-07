import cdk = require("@aws-cdk/core");
import cloudfront = require("@aws-cdk/aws-cloudfront");
import iam = require("@aws-cdk/aws-iam");
import s3 = require("@aws-cdk/aws-s3");
import s3deploy = require("@aws-cdk/aws-s3-deployment");
import path = require('path');
import { Tagger, StackNames }  from "./tagger-helper";

export class FrontendStack extends cdk.Stack {

  constructor(scope: cdk.Construct, id: string) {
    super(scope, id);

    let stack = StackNames.Ecs;
    Tagger.Tag(this, stack);

    // Obtain the content directory from CDK context
    const webAppRoot = path.resolve(__dirname, '..', '..', 'frontend', 'dist');

    // Create a S3 bucket, with the given name and define the web index document as 'index.html'
    const bucket = new s3.Bucket(this, "Bucket", {
      websiteIndexDocument: "index.html"
    });
    Tagger.Tag(bucket, stack);

    // Obtain the cloudfront origin access identity so that the s3 bucket may be restricted to it.
    const origin = new cloudfront.OriginAccessIdentity(this, "BucketOrigin", {
        comment: "mythical-mysfits"
    });
    Tagger.Tag(origin, stack);

    // Restrict the S3 bucket via a bucket policy that only allows our CloudFront distribution
    bucket.grantRead(new iam.CanonicalUserPrincipal(
      origin.cloudFrontOriginAccessIdentityS3CanonicalUserId
    ));

    // Definition for a new CloudFront web distribution, which enforces traffic over HTTPS
    const cdn = new cloudfront.CloudFrontWebDistribution(this, "CloudFront", {
      viewerProtocolPolicy: cloudfront.ViewerProtocolPolicy.ALLOW_ALL,
      priceClass: cloudfront.PriceClass.PRICE_CLASS_ALL,
      originConfigs: [
        {
          behaviors: [
            {
              isDefaultBehavior: true,
              maxTtl: undefined,
              allowedMethods:
                cloudfront.CloudFrontAllowedMethods.GET_HEAD_OPTIONS
            }
          ],
          originPath: `/web`,
          s3OriginSource: {
            s3BucketSource: bucket,
            originAccessIdentity: origin
          }
        }
      ]
    });
    Tagger.Tag(cdn, stack);

    // A CDK helper that takes the defined source directory, compresses it, and uploads it to the destination s3 bucket.
    new s3deploy.BucketDeployment(this, "DeployWebsite", {
      sources: [s3deploy.Source.asset(webAppRoot)],
      destinationKeyPrefix: "web/",
      destinationBucket: bucket,
      distribution: cdn,
      retainOnDelete: false,
    });

    // Create a CDK Output which details the URL for the CloudFront Distribtion URL.
    new cdk.CfnOutput(this, "CloudFrontURL", {
      description: "The CloudFront distribution URL",
      value: "http://" + cdn.domainName
    });
  }
}
