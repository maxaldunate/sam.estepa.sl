# SAM Estepa Serverless CDK TypeScript

## Contents

* [Useful commands](#useful-commands)
* [CDK Dependency Tree](#cdk-dependency-tree)
* [CDK Creation](#cdk-creation)
* [Destroy all resources](#destroy-all-resources)

## Useful commands

 * `npm run build`   compile typescript to js
 * `npm run watch`   watch for changes and compile
 * `npm run test`    perform the jest unit tests
 * `cdk deploy`      deploy this stack to your default AWS account/region
 * `cdk diff`        compare deployed stack with current state
 * `cdk synth`       emits the synthesized CloudFormation template


## CDK Dependency Tree

### Independent Stacks

Num | Stack Name | Use | Used By
------------ | ------------- | ------------- | -------------
1| Frontend| None|None
2| XRay|None|None
3| Cognito|None|[9]-ApiGateway
4| DevTools|None|[11]-CICD
5| Network|None|[7]-ECS, [8]-Dynamo
6| ECR|None|[7]-ECS, [11]-CICD
7|ECS|[5]-Network.vpc, [6]-ECR.ecrRepository|[8]-DynamoDB, [9]-ApiGateway, [11]-CICD
8|DynamoDB|[5]-Network.vpc,[7]-ECS.ecsService.service|[10]-KinesisFirehose
9|ApiGateway|[3]-Cognito.userPool.userPoolId, [7]-ECS.ecsService.loadBalancer.loadBalancerArn, [7]-ECS.ecsService.loadBalancer.loadBalancerDnsName|[10]-KinesisFirehose
10|KinesisFirehose|[8]-DynamoDBStack.table,[9]-ApiGateway.apiId|None
11|CICD|[6]-ECR.ecrRepository, [7]-ECS.ecsService.service, [4]-DevTools.apiRepository.repositoryArn|None
9|ApiGateway|<ul><li>[3]-Cognito.userPool.userPoolId</li><li>[7]-ECS.ecsService.loadBalancer.loadBalancerArn</li><li>[7]-ECS.ecsService.loadBalancer.loadBalancerDnsName</li></ul>|[10]-KinesisFirehose








1. Frontend.    Used by None
2. XRay.        Used by None
3. Cognito.     Used by [9]-ApiGateway
4. DevTools.    Used by [11]-CICD
5. Network.     Used by [7]-ECS, [8]-Dynamo
6. ECR.         Used by [7]-ECS, [11]-CICD

### Stack with their dependencies

7. ECS          Used by [8]-DynamoDB, [9]-ApiGateway, [11]-CICD
    * [5]-Network.vpc,
    * [6]-ECR.ecrRepository

8. DynamoDB     Used by [10]-KinesisFirehose
    * [5]-Network.vpc,
    * [7]-ECS.ecsService.service

9. ApiGateway   Used by [10]-KinesisFirehose
    * [3]-Cognito.userPool.userPoolId,
    * [7]-ECS.ecsService.loadBalancer.loadBalancerArn, ECS.ecsService.loadBalancer.loadBalancerDnsName

10. KinesisFirehose
    DynamoDBStack.table,
    ApiGateway.apiId

11. CICD
    * [6]-ECR.ecrRepository,
    * [7]-ECS.ecsService.service,
    * [4]-DevTools.apiRepository.repositoryArn



### Commands to deploy & destroy an stack by name
```bash
cdk deploy  --profile samsoftware-estepa --require-approval never EstepaDev-STACK_NAME
cdk destroy --profile samsoftware-estepa --require-approval never EstepaDev-STACK_NAME
```


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

### Web Api Load Balancer endpoint
```
aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name EstepaDev-ECS --query "Stacks[0].Outputs[?OutputKey=='ServiceLoadBalancerDNSEC5B149E'].OutputValue" --output text
Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com

curl http://PREVIOUS_OUTPUT/api/mysfits
curl http://Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/api/mysfits
```


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