# Sam Estepa Serverless
Max Aldunate - Notes on Windows 10

## Module 1 - IDE Setup and Static Website Hosting

### Frontend dist
 
`npm install -g aws-cdk`
`npm install -g @angular/cli`


In C:\git\olds_max\sam.estepa.serverless\frontend\package.json

replace 
"ng": "./node_modules/@angular/cli/bin/ng"
by
"ng",


Final
```
  "scripts": {
    "ng": "ng",
    "start": "npm install && ng serve",
    "build": "ng build",
    "test": "ng test",
    "lint": "ng lint",
    "e2e": "ng e2e"
  },
```  
  

In C:\git\olds_max\sam.estepa.serverless\frontend

Admin PowerShell
`npm update`
`ng build`
`npm run build -- --prod`

### Aws Cdk

`cdk init app --language=typescript`

In terminal ...
`npm run watch`


### CloudFormation

**Before set Aws Credentials**
In C:\Users\wille\.aws\config
```
aws_access_key_id=AKIAIFXI6W6KPVB6G43A
aws_secret_access_key=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
region = eu-west-1
output = json
```
Check In C:\Users\wille\.aws\credentials

### View and deploy Template
`npm run watch`
`cdk synth EstepaDev-DeveloperTools`
`cdk synth EstepaDev-DeveloperTools > cloudformations\DeveloperTools.yaml`
`cdk deploy EstepaDev-DeveloperTools --profile estepa`

[Link to configure](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up.html)

### Git Repos

[Setup Steps for HTTPS Connections to AWS CodeCommit Repositories on Windows with the AWS CLI Credential Helper](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-windows.html)

[Setup for HTTPS Users Using Git Credentials](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-gc.html)

`git remote add origin <<Your Web CodeCommit HTTPS Repository Clone URL>`
`$ frontend> git remote add origin https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/259129723241-EstepaDevService-Repository-Web`
`$ cdk> git remote add origin https://git-codecommit.eu-west-1.amazonaws.com/v1/repos/259129723241-EstepaDevService-Repository-CDK`

### Deploy the Website and Infrastructure

`cdk bootstrap --profile estepa`
`cdk synth EstepaDev-WebApplication > cloudformations\WebApplication.yaml`
`cdk deploy EstepaDev-WebApplication --profile estepa`

## Module 2 - Creating a Service with AWS Fargate

### Building A Docker Image

```bash
aws sts get-caller-identity --profile estepa

docker build . -t 259129723241.dkr.ecr.eu-west-1.amazonaws.com/EstepaDev/service:latest

	Successfully built b31ab405c96b
	Successfully tagged 259129723241.dkr.ecr.eu-west-1.amazonaws.com/EstepaDev/service:latest

	SECURITY WARNING: You are building a Docker image from Windows against a non-Windows Docker host. All files and directories added to build context will have '-rwxr-xr-x' permissions. It is recommended to double check and reset permissions for sensitive files and directories.


docker run -p 8080:8080 259129723241.dkr.ecr.eu-west-1.amazonaws.com/EstepaDev/service:latest

In Browser
http://0.0.0.0:8080/api/mysfits

http://192.168.99.100:8080/api/mysfits
```


### [Portainer](https://www.portainer.io/)

```
docker volume create portainer_data

docker run -d -p 8000:8000 -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer

Browser http://192.168.99.100:9000

```

### Create Nertwork Stack

```bash
npm install --save-dev @aws-cdk/aws-ec2
cdk synth EstepaDev-NetworkStack -o templates --profile
cdk deploy EstepaDev-ECR --profile estepa

aws sts get-caller-identity --query Account --output text --profile estepa
259129723241

aws configure get region --profile estepa
eu-west-1

aws sts get-caller-identity --profile estepa

  {
      "UserId": "259129723241",
      "Account": "259129723241",
      "Arn": "arn:aws:iam::259129723241:root"
  }

Install-Package -Name AWSPowerShell

aws ecr get-login-password --profile estepa | docker login --username AWS --password-stdin 259129723241.dkr.ecr.eu-west-1.amazonaws.com/EstepaDev/service

docker push 259129723241.dkr.ecr.eu-west-1.amazonaws.com/EstepaDev/service:latest

aws ecr describe-images --repository-name EstepaDev/service --profile estepa
  {
      "imageDetails": [
          {
              "registryId": "259129723241",
              "repositoryName": "EstepaDev/service",
              "imageDigest": "sha256:e75fb76d7d02b7e501ffafcf384567ee06548fb4fd69766f5a6fda514b902757",
              "imageTags": [
                  "latest"
              ],
              "imageSizeInBytes": 44812724,
              "imagePushedAt": "2020-05-05T00:39:02+02:00"
          }
      ]
  }

```

### Creating a Service Linked Role for ECS

```bash

aws iam create-service-linked-role --aws-service-name ecs.amazonaws.com --profile estepa
        {
            "Role": {                                                                                                                                              
                "Path": "/aws-service-role/ecs.amazonaws.com/",                                                                                                    
                "RoleName": "AWSServiceRoleForECS",                                                                                                                
                "RoleId": "AROATYVKVZFURAXFXZGAV",                                                                                                                 
                "Arn": "arn:aws:iam::259129723241:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS",
                "CreateDate": "2020-05-04T22:47:02+00:00",
                "AssumeRolePolicyDocument": {
                    "Version": "2012-10-17",
                    "Statement": [
                        {
                            "Action": [
                                "sts:AssumeRole"                                                                                                                   
                            ],                                                                                                                                     
                            "Effect": "Allow",                                                                                                                     
                            "Principal": {                                                                                                                         
                                "Service": [                                                                                                                       
                                    "ecs.amazonaws.com"                                                                                                            
                                ]
                            }
                        }
                    ]
                }
            }
        }

cdk deploy EstepaDev-ECS --profile estepa

-- Test the Service
https://eu-west-1.console.aws.amazon.com/ec2/v2/home?region=eu-west-1#LoadBalancers:sort=loadBalancerName

-- curl http://<replace-with-your-nlb-address>/api/mysfits

curl http://Mythi-Servi-1LDDCJMQ03ZVK-63b3d5655ebf7fbf.elb.eu-west-1.amazonaws.com/api/mysfits


      StatusDescription : OK
      Content           : {"mysfits":[{"mysfitId":"4e53920c-505a-4a90-a694-b9300791f0ae","name":"Evangeline","species":"Chimera","age":43,"description":"Evange ed
                          line is the global sophisticate of the mythical world. You’d be har...
      RawContent        : HTTP/1.1 200 OK
                          Transfer-Encoding: chunked
                          Content-Type: application/json; charset=utf-8
                          Date: Mon, 04 May 2020 23:10:20 GMT
                          Server: Kestrel

                          {"mysfits":[{"mysfitId":"4e53920c-505a-4a90-a694-b93...
      Forms             : {}
      Headers           : {[Transfer-Encoding, chunked], [Content-Type, application/json; charset=utf-8], [Date, Mon, 04 May 2020 23:10:20 GMT], [Server,       
                          Kestrel]}
      Images            : {}
      InputFields       : {}
      Links             : {}
      ParsedHtml        : mshtml.HTMLDocumentClass
      RawContentLength  : 4487


```

### Replace the API Endpoint and Upload to S3 and Deploy
```

in /frontend
npm install
npm updtae
ng build -- --prod

in /cdk
npm run build
cdk deploy EstepaDev-WebApplication --profile estepa

```


### Deploy the CI/CD Pipeline

```
in /cdk 
npm run build
cdk deploy EstepaDev-CICD --profile estepa

```

### Endpoints
* Web API
   http://mythi-servi-1lddcjmq03zvk-63b3d5655ebf7fbf.elb.eu-west-1.amazonaws.com/api/mysfits
* Static Bucket
   http://mythical-mysfits-frontend-259129723241.s3-website-eu-west-1.amazonaws.com/
* CloudFront Endpoint
   http://d1u2xfsf566d4p.cloudfront.net/


## Module 3 - Adding a Data Tier with Amazon DynamoDB

* Add DynamoDbStack

```bash
npm run build
cdk deploy EstepaDev-DynamoDB --profile estepa
aws dynamodb describe-table --table-name MysfitsTable --profile estepa

            {
                "Table": {
                    "AttributeDefinitions": [
                        {
                            "AttributeName": "GoodEvil",
                            "AttributeType": "S"
                        },
                        {
                            "AttributeName": "LawChaos",
                            "AttributeType": "S"
                        },
                        {
                            "AttributeName": "MysfitId",
                            "AttributeType": "S"
                        }
                    ],
                    "TableName": "MysfitsTable",
                    "KeySchema": [
                        {
                            "AttributeName": "MysfitId",
                            "KeyType": "HASH"
                        }
                    ],
                    "TableStatus": "ACTIVE",
                    "CreationDateTime": "2020-05-05T12:15:26.851000+02:00",
                    "ProvisionedThroughput": {
                        "NumberOfDecreasesToday": 0,
                        "ReadCapacityUnits": 5,
                        "WriteCapacityUnits": 5
                    },
                    "TableSizeBytes": 0,
                    "ItemCount": 0,
                    "TableArn": "arn:aws:dynamodb:eu-west-1:259129723241:table/MysfitsTable",
                    "TableId": "4a154b30-a009-4e58-a088-25fd90087b68",
                    "GlobalSecondaryIndexes": [
                        {
                            "IndexName": "LawChaosIndex",
                            "KeySchema": [
                                {
                                    "AttributeName": "LawChaos",
                                    "KeyType": "HASH"
                                },
                                {
                                    "AttributeName": "MysfitId",
                                    "KeyType": "RANGE"
                                }
                            ],
                            "Projection": {
                                "ProjectionType": "ALL"
                            },
                            "IndexStatus": "ACTIVE",
                            "ProvisionedThroughput": {
                                "NumberOfDecreasesToday": 0,
                                "ReadCapacityUnits": 5,
                                "WriteCapacityUnits": 5
                            },
                            "IndexSizeBytes": 0,
                            "ItemCount": 0,
                            "IndexArn": "arn:aws:dynamodb:eu-west-1:259129723241:table/MysfitsTable/index/LawChaosIndex"
                        },
                        {
                            ],
                            "Projection": {
                                "ProjectionType": "ALL"
                            },
                            "IndexStatus": "ACTIVE",
                            "ProvisionedThroughput": {
                                "NumberOfDecreasesToday": 0,
                                "ReadCapacityUnits": 5,
                                "WriteCapacityUnits": 5
                            },
                            "IndexSizeBytes": 0,
                            "ItemCount": 0,
                            "IndexArn": "arn:aws:dynamodb:eu-west-1:259129723241:table/MysfitsTable/index/GoodEvilIndex"
                        }
                    ]
                }
            }

aws dynamodb scan --table-name MysfitsTable --profile estepa
            {
                "Items": [],
                "Count": 0,
                "ScannedCount": 0,
                "ConsumedCapacity": null
            }

```

### Adding Items

```
In /cdk/data
aws dynamodb batch-write-item --request-items file://populate-dynamodb.json --profile estepa
        {
            "UnprocessedItems": {}
        }
aws dynamodb scan --table-name MysfitsTable --profile estepa
        {
            "Items": [
                {
                    "ThumbImageUri": {
                        "S": "https://www.EstepaDev.com/images/haetae_thumb.png"
                    },
                    "LawChaos": {
                        "S": "Neutral"
                    },
                    "GoodEvil": {
                        "S": "Good"
                    },
                    "Adopted": {
                        "BOOL": false
                    },
                    "Species": {
                        "S": "Haetae"
                    },
                    "Description": {

                        ...
                        ...
            ],
            "Count": 12,
            "ScannedCount": 12,
            "ConsumedCapacity": null
        }
```

### Committing The First Real Code change

```
Copy webapi
dotnet build

```

### Update The Website Content in S3

```
Copy frontend
in /frontend
npm install
npm updtae
ng build -- --prod

in /cdk
npm run build
cdk deploy EstepaDev-WebApplication --profile estepa

```
### Deploy ASll Full Stacks
```cdk synth * -o templates --profile estepa
cdk deploy *  --require-approval never --profile estepa
```
DELETE ClodWatch Logs

## Module 4 - Adding User and API Features with Amazon API Gateway and AWS Cognito

* Create cognito-stack.ts & api-gateway-stack.ts
    `npm install --save-dev @aws-cdk/aws-apigateway`
    `npm install --save-dev @aws-cdk/aws-cognito`

* Install Aplify 
    `npm install -g @aws-amplify/cli`
    `amplify configure`

* Deploy Aws Cognito & API Gateway


## Module 5 - Capturing User Behavior

dotnet restore
dotnet publish

git clone ssh://git-codecommit.eu-west-1.amazonaws.com/v1/repos/085693846076-EstepaDevService-Repository-Lambda lambda

git clone git@github.com:maxaldunate/sam.estepa.serverless.git
dotnet tool install -g Amazon.Lambda.Tools
npm install --save-dev @aws-cdk/aws-kinesisfirehose@1.36.1

`cdk deploy EstepaDev-KinesisFirehose --profile samsoftware-estepa --require-approval never`

Outputs:
EstepaDev-KinesisFirehose.APIEndpoint87847821 = https://sjuyhfvjek.execute-api.eu-west-1.amazonaws.com/prod/

npm install -g @aws-amplify/cli
amplify configure
cdk deploy EstepaDev-WebApplication --profile samsoftware-estepa --require-approval never

REVISAR TODO EL MODULO 5 y APUNTAR TODO LO QUE HE EJECUTADO


## Module 6 - Tracing Application Requests

npm install --save-dev @aws-cdk/aws-sns @aws-cdk/aws-sns-subscriptions @aws-cdk/aws-lambda-event-sources
copy ~/Workshop/source/module-6/lambda/* to /lambda
cd /lambda/PostQuestionsService
dotnet restore
dotnet publish
cd /lambda/ProcessQuestionsStream
dotnet restore
dotnet publish
cd /cdk
cdk deploy EstepaDev-XRay --profile samsoftware-estepa --require-approval never
    EstepaDev-XRay.APIEndpoint87847821 = https://uhziz5z73k.execute-api.eu-west-1.amazonaws.com/prod/
* Deploy Frontend
cp -r ~/workshop/source/module-6/frontend/* /frontend
cd /frontend

in file frontend/index.html
    var mysfitsApiEndpoint = 'https://9ju8mg800c.execute-api.eu-west-1.amazonaws.com/prod/'; // example: 'https://abcd12345.execute-api.us-east-1.amazonaws.com/prod'
    var streamingApiEndpoint = 'https://sjuyhfvjek.execute-api.eu-west-1.amazonaws.com/prod/'; // example: 'https://abcd12345.execute-api.us-east-1.amazonaws.com/prod'
    var questionsApiEndpoint = 'https://uhziz5z73k.execute-api.eu-west-1.amazonaws.com/prod/'; // example: 'https://abcd12345.execute-api.us-east-1.amazonaws.com/prod'

    var cognitoUserPoolId = 'eu-west-1_d7fdSAgua';  // example: 'us-east-1_abcd12345'
    var cognitoUserPoolClientId = '7tnqml77fnoe0rde2nu2ar58nv'; // example: 'abcd12345abcd12345abcd12345'
    var awsRegion = 'eu-west-1'; // example: 'us-east-1' or 'eu-west-1' etc.

ng build -- --prod
cd /cdk
cdk deploy EstepaDev-WebApplication --profile samsoftware-estepa --require-approval never


