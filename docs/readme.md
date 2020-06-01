# Sam Estepa Serverless
Max Aldunate - Notes on Windows 10

* Summary of Estema Serverless
* TAG {"project": "estepa-dev"} 

# Contents
* [Daily Use](#daily-use)
    - [Debug frontend](#debug-frontend)
    - [Deploy frontend](#deploy-frontend)

* [Detailed Notes](/docs/readme-modules.md)
    - [Module 1 - IDE Setup and Static Website Hosting](/docs/readme-modules.md#module-1---IDE-Setup-and-Static-Website-Hosting)
    - [Module 2 - Creating a Service with AWS Fargate](/docs/readme-modules.md#Module-2---Creating-a-Service-with-AWS-Fargate)
    - [Module 3 - Adding a Data Tier with Amazon DynamoDB](/docs/readme-modules.md#Module-3---Adding-a-Data-Tier-with-Amazon-DynamoDB)
    - [Module 4 - Adding User and API Features with Amazon API Gateway and AWS Cognito](/docs/readme-modules.md#Module-4---Adding-User-and-API-Features-with-Amazon-API-Gateway-and-AWS-Cognito)
    - [Module 5 - Capturing User Behavior](/docs/readme-modules.md#Module-5---Capturing-User-Behavior)
    - [Module 6 - Tracing Application Requests](/docs/readme-modules.md#Module-6---Tracing-Application-Requests)

* [GitHub Repos](#gitHub-repos)
* [Install Environment (Onboarding)](#Install-Environment-Onboarding) revisar link
* [CDK Dependency Tree](#CDK-Dependency-Tree)
* [CDK Creation](#CDK-Creation)
* [Check Deployment](#Check-Deployment)
* [Destroy all resources](#Destroy-all-resources)
* [Special sometimes notes](#-Special-sometimes-notes)
* [Pending Tasks](#Pending-Tasks)

# Daily Use

## Debug frontend 
    - `cd ~/frontend && npm run start`
    - browser on [http://localhost:4200/](http://localhost:4200/)
## Deploy frontend
    - `npm run build`
    - `cd ~/cdk && npm run build`
    - `cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Frontend`



## Pending Tasks
* unify in one repo
* rename all mymys
* Make a s3 assets
* Make an "on boarding" document
* Multitenant service
* Debug lambda on docker
* Make clicks working
* Make question's working
* Log&Performance serilog, elasticsearch and kibana
* Put in cognito stack: Cognito Console: MysfitsUserPool/Policies/Allow users to sign themselves up
* Add notification to EstepaDevServiceCodeBuildProject if Build failed
* Remove every resource of a aws account (https://github.com/rebuy-de/aws-nuke)
* Dejar los Git repos que sean indisènsables en aws y mover el resto a github (crear para cada)
* Renombrar Git Repos
* Some Stacks are auto-run... check it, eg. Network
* Everything in one git repo. Pushing each folder to deploy
* seed data populate-dynamodb.json
* migrate from Dynamo to MySql+EF Core
* Modify cloud watch for detailed logs
* Add Expire days to logs on cloud watchs
* Make NLB private (not internet open) 
    https://github.com/aws-samples/aws-modern-application-workshop/tree/dotnet-cdk/module-4#adding-a-new-rest-api-with-amazon-api-gateway
    "In a real-world scenario, you should create your NLB to be internal from the beginning"
* Tagging Resources
* Create all in a new account, previously deactivate regions
* S3 file retention for artifacts, etc
* Understand cdk  tree dependency
* how to debug each component



## GitHub Repos
* Sam Estepa Serverless CDK         [sam.estepa.sl.cdk](https://github.com/maxaldunate/sam.estepa.sl.cdk.git)
* Sam Estepa Serverless Docs        [sam.estepa.sl.docs](https://github.com/maxaldunate/sam.estepa.sl.docs.git)
* Sam Estepa Serverless Frontend    [sam.estepa.sl.frontend](https://github.com/maxaldunate/sam.estepa.sl.frontend.git)
* Sam Estepa Serverless Lambda      [sam.estepa.sl.lambda](https://github.com/maxaldunate/sam.estepa.sl.lambda.git)
* Sam Estepa Serverless Web API     [sam.estepa.sl.webapi](https://github.com/maxaldunate/sam.estepa.sl.webapi.git)

## Install Environment (Onboarding)
aws cli
npm
node
agular cli

```
dotnet tool install -g Amazon.Lambda.Tools
    You can invoke the tool using the following command: dotnet-lambda
    Tool 'amazon.lambda.tools' (version '4.0.0') was successfully installed.
```


### CDK Dependency Tree

Frontend
XRay
Cognito
DevTools
Network
ECR

ECS
    Network.vpc,
    ECR.ecrRepository

DynamoDB
    Network.vpc,
    ECS.ecsService.service

ApiGateway
    Cognito.userPool.userPoolId,
    ECS.ecsService.loadBalancer.loadBalancerArn, ECS.ecsService.loadBalancer.loadBalancerDnsName

KinesisFirehose
    DynamoDBStack.table,
    ApiGateway.apiId

CICD
    ECR.ecrRepository,
    ECS.ecsService.service,
    DevTools.apiRepository.repositoryArn

cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-
cdk destroy --profile samsoftware-estepa --require-approval never EstepaDev-


## CDK Creation

1. Create Aws Account
    Download root credentials
    Deactivate all region except eu-west-1 ()[https://console.aws.amazon.com/iam/home?region=us-east-2#/account_settings]
    Create IAM user programmatic access only, adding AdministratorAccess permission policy
    Download credentials
    Create IAM user programmatic access only, adding AWSCodeCommitPowerUser permission policy
    [Setup Steps for SSH Connections to AWS CodeCommit Repositories on Windows](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-windows.html)
    C:\Users\wille\.ssh\config
    Push ssh-key codecommit_rda to IAM/Users/git-user/Upload SSh public key
    Add profile to AWS CLI
        aws configure --profile samsoftware-estepa
        aws configure --profile samsoftware-git
        C:\Users\user_name\.aws\config
        C:\Users\user_name\.aws\credentials
    Remove Root User Credentials

2. Deploy CDK Tool Kit and independent stacks: Frontend, XRay, Cognito, DevTools, Network & ECR
```
cdk bootstrap --profile samsoftware-estepa
    aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name CDKToolkit --query "Stacks[0].Outputs[?OutputKey=='BucketName'].OutputValue" --output text
        cdktoolkit-stagingbucket-kojjbsgyuii5
    aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name CDKToolkit --query "Stacks[0].Outputs[?OutputKey=='BucketDomainName'].OutputValue" --output text
        cdktoolkit-stagingbucket-kojjbsgyuii5.s3.eu-west-1.amazonaws.com
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Frontend
    Outputs:
    EstepaDev-Frontend.CloudFrontURL = http://dk5h77d8loqzp.cloudfront.net
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-XRay
    Outputs:
    EstepaDev-XRay.APIEndpoint87847821 = https://wbrfhak3b4.execute-api.eu-west-1.amazonaws.com/prod/
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Cognito
    No Outputs
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-DevTools
    Outputs:
    EstepaDev-DevTools.APIRepositoryCloneUrlSsh = ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Webapi
    EstepaDev-DevTools.lambdaRepositoryCloneUrlSsh = ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Lambda
    EstepaDev-DevTools.CDKRepositoryCloneUrlSsh = ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-CDK
    EstepaDev-DevTools.WebRepositoryCloneUrlSsh = ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Frontend
    EstepaDev-DevTools.ExportsOutputFnGetAttAPIRepository40476B48ArnA6DB1E5D = arn:aws:codecommit:eu-west-1:085693846076:085693846076-EstepaDevService-Repository-Webapi
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Network
    Outputs:
    EstepaDev-Network.ExportsOutputRefVPCB9E5F0B4BD23A326 = vpc-0744eae34fd40039b
    EstepaDev-Network.ExportsOutputRefVPCPrivateSubnet2SubnetCFCDAA7AB22CF85D = subnet-0bea8df68b5358713
    EstepaDev-Network.ExportsOutputFnGetAttVPCB9E5F0B4CidrBlock723DF8C0 = 10.0.0.0/16
    EstepaDev-Network.ExportsOutputRefVPCPublicSubnet1SubnetB4246D30D84F935B = subnet-0f585c19ccc9f58ba
    EstepaDev-Network.ExportsOutputRefVPCPrivateSubnet1Subnet8BCA10E01F79A1B7 = subnet-0255fc4d442d16cda
    EstepaDev-Network.ExportsOutputRefVPCPublicSubnet2Subnet74179F3969CC10AD = subnet-0055320b809b1ef4c
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-ECR
    Outputs:
    EstepaDev-ECR.ExportsOutputRefRepository22E53BBD9A9E013B = estepadev/service
    EstepaDev-ECR.ExportsOutputFnGetAttRepository22E53BBDArn3AD4E30B = arn:aws:ecr:eu-west-1:085693846076:repository/estepadev/service
```

3. Push code to Git Repos on CodeCommit with git-user
    [Setup Steps for SSH Connections to AWS CodeCommit Repositories on Windows](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-windows.html)
    [Migrate a Git Repository to AWS CodeCommit](https://docs.aws.amazon.com/codecommit/latest/userguide/how-to-migrate-repository-existing.html)
    ```
    \cdk>      git push --all ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-CDK
    \webapi>   git push --all ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Webapi
    \frontend> git push --all ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Frontend
    \lambda>   git push --all ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Lambda
    ```

4. Push Docker Image
    - In C:\Users\wille\.aws\credentials remove toolkit_artifact_guid
    * In Folder \webapi>
    ```
    aws sts get-caller-identity --query Account --output text --profile samsoftware-estepa
        085693846076
    aws configure get region --profile samsoftware-estepa
        eu-west-1
    aws ecr get-login-password --profile samsoftware-estepa | docker login --username AWS --password-stdin 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service
        Login Succeeded
    
    docker build . -t 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker push 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker run -p 8080:8080 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest

    http://Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/api/mysfits
    http://192.168.99.100:8080/api/mysfits

    ```

5. Deploy Dependent Stacks: ECS, DynamoDB
```
cdk deploy EstepaDev-ECS             --profile samsoftware-estepa --require-approval never
    Outputs:
    EstepaDev-ECS.ExportsOutputFnGetAttService9571FDD8Name56F663B1 = EstepaDev-ECS-Service9571FDD8-1I9J63HGNT76K
    EstepaDev-ECS.ExportsOutputRefServiceLBE9A1ADBC8915B274 = arn:aws:elasticloadbalancing:eu-west-1:085693846076:loadbalancer/net/Estep-Servi-195O26F1ZHFC1/cb324d4be6285e6d
    EstepaDev-ECS.ExportsOutputRefClusterEB0386A796A0E3FE = EstepaDev-ECS-ClusterEB0386A7-X7zm24YdzDKs
    EstepaDev-ECS.ServiceLoadBalancerDNSEC5B149E = Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-DynamoDB
    Outputs:
    EstepaDev-DynamoDB.ExportsOutputFnGetAttTableCD117FA1ArnE2C8C204 = arn:aws:dynamodb:eu-west-1:085693846076:table/MysfitsTable
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-APIGateway
    Outputs:
    EstepaDev-APIGateway.ExportsOutputRefSchema2070DD45 = fma29g1jh9
    EstepaDev-APIGateway.APIID = fma29g1jh9
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-KinesisFirehose
    Outputs:
    EstepaDev-KinesisFirehose.APIEndpoint87847821 = https://pya3zcp8a2.execute-api.eu-west-1.amazonaws.com/prod/
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-CICD
    No Outputs
```

6. Seed Data
```
cd cdk/data
aws dynamodb scan --table-name MysfitsTable --profile samsoftware-estepa
aws dynamodb batch-write-item --request-items file://populate-dynamodb.json --profile samsoftware-estepa
        {
            "UnprocessedItems": {}
        }
aws dynamodb scan --table-name MysfitsTable --profile samsoftware-estepa
```

7. Replace Endpoints on Web App & Swagger

* Endpoints
    ```
    var mysfitsApiEndpoint   = 'REPLACE_ME'; // example: 'https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/prod'
    var streamingApiEndpoint = 'REPLACE_ME'; // example: 'https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/prod'
    var questionsApiEndpoint = 'REPLACE_ME'; // example: 'https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/prod'

    aws configure get region --profile samsoftware-estepa
        eu-west-1
    aws apigateway get-rest-apis --profile samsoftware-estepa --query 'items[?name==`MysfitsApi`][id]' --output text
        fma29g1jh9
    aws apigateway get-rest-apis --profile samsoftware-estepa --query 'items[?name==`ClickProcessing API Service`][id]' --output text
        pya3zcp8a2
    aws apigateway get-rest-apis --profile samsoftware-estepa --query 'items[?name==`Questions API Service`][id]' --output text
        wbrfhak3b4
    ```

* In File "/frontend/src/environments/environment.prod.ts"
    CON O SIN API AL FINAL           https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api???
    ```
    {
        mysfitsApiUrl:              'https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod',
        mysfitsStreamingServiceUrl: 'https://pya3zcp8a2.execute-api.eu-west-1.amazonaws.com/prod',
    }
    ```

* In File "/frontend/index.html"
    CON O SIN API AL FINAL      https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api???
    ```
    var mysfitsApiEndpoint   = 'https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api';
    
    var streamingApiEndpoint = 'https://pya3zcp8a2.execute-api.eu-west-1.amazonaws.com/prod/';
    pya3zcp8a2
    
    var questionsApiEndpoint = 'https://
    .execute-api.eu-west-1.amazonaws.com/prod/';

    var cognitoUserPoolId = 'eu-west-1_d7fdSAgua';  // example: 'us-east-1_abcd12345'
    var cognitoUserPoolClientId = '7tnqml77fnoe0rde2nu2ar58nv';
    var awsRegion = 'eu-west-1';
    ```

8. Redeploy Web Application
```
cd ~/frontend>
npm install
ng build -- --prod 
    or npm run build -- --prod
cd ~/cdk
npm run build
cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Frontend
    Outputs:
    EstepaDev-Frontend.CloudFrontURL = http://dk5h77d8loqzp.cloudfront.net
```



### Debugging
```
    docker build . -t 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker push 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker run -p 8080:8080 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest

In Browser Hit
http://Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/api/mysfits
http://192.168.99.100:8080/api/mysfits

```






## Check Deployment

### Web Api Load Balancer endpoint
```
aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name EstepaDev-ECS --query "Stacks[0].Outputs[?OutputKey=='ServiceLoadBalancerDNSEC5B149E'].OutputValue" --output text
Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com

curl http://PREVIOUS_OUTPUT/api/mysfits
curl http://Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/api/mysfits
```


### CloudFront to Hit Web App
```
aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name EstepaDev-Frontend --query "Stacks[0].Outputs[?OutputKey=='CloudFrontURL'].OutputValue" --output text
http://d1u2xfsf566d4p.cloudfront.net/

```







## Destroy all resources

### Destroy Cloudformations Stacks
```
cdk destroy EstepaDev-XRay --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-KinesisFirehose --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-APIGateway --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-Cognito --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-ECS --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-DynamoDB --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-Frontend --require-approval never --profile samsoftware-estepa

cdk destroy EstepaDev-ECR --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-DeveloperTools --require-approval never --profile samsoftware-estepa
cdk destroy EstepaDev-Network --require-approval never --profile samsoftware-estepa
```

### Not Destroyed Resources 
* [Tables with Data](https://eu-west-1.console.aws.amazon.com/dynamodb/home?region=eu-west-1#tables:)
* [Buckets with data](https://s3.console.aws.amazon.com/s3/home?region=eu-west-1#)
* [ECR -Amazon Container Services - Registry](https://eu-west-1.console.aws.amazon.com/ecr/repositories?region=eu-west-1#)
* [ECS Task Definitions](https://eu-west-1.console.aws.amazon.com/ecs/home?region=eu-west-1#/taskDefinitions)
* [CloudWatch Log Groups](https://eu-west-1.console.aws.amazon.com/cloudwatch/home?region=eu-west-1#logs:)

### Not sure if you have to delete
* [KMS - AWS managed keys](https://eu-west-1.console.aws.amazon.com/kms/home?region=eu-west-1#/kms/defaultKeys)
* [KMS - Customer managed keys](https://eu-west-1.console.aws.amazon.com/kms/home?region=eu-west-1#/kms/keys)


### Destroy CDKToolkit
* Get Bucket Name
`aws cloudformation describe-stack-resources --stack-name CDKToolkit --profile samsoftware-estepa`
* Empty bucket before destroy stack
`aws s3 rm s3://bucket-name --recursive --profile samsoftware-estepa`
`aws s3 rm s3://cdktoolkit-stagingbucket-opndhwgmnw42 --recursive --profile samsoftware-estepa`
* Delete stack & resources
`aws cloudformation delete-stack --stack-name CDKToolkit --profile samsoftware-estepa`


### Special sometimes notes

* Load balancer 'arn:aws:elasticloadbalancing:eu-west-1:259129723241:loadbalancer/net/Mythi-Servi-NSP2SIN9TDC9/2c63e2c71a2287bb' cannot be deleted because it is currently associated with another service (Service: AmazonElasticLoadBalancingV2; Status Code: 400; Error Code: ResourceInUse; Request ID: 2a0420a3-66c4-4a72-9435-108ce8c4da4a)


* From Console Trying to remove LoadBalancer (EC2)
Load balancer 'arn:aws:elasticloadbalancing:eu-west-1:259129723241:loadbalancer/net/Mythi-Servi-NSP2SIN9TDC9/2c63e2c71a2287bb' cannot be deleted because it is currently associated with another service

`aws Load balancer  cannot be deleted because it is currently associated with another service`

Delete a Network Load Balancer
https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-delete.html

You can't delete a load balancer if it is in use by  VPC endpoint service

aws endpoint service has existing active VPC Endpoint connections

Deleting a VPC endpoint
https://docs.aws.amazon.com/vpc/latest/userguide/delete-vpc-endpoint.html



