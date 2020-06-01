# SAM Estepa Serverles Project 
Max Aldunate

* Summary of Estema Serverless
* TAG {"project": "estepa-dev"} 

## Contents

* In this doc
    * [Daily Use](#daily-use)
    * [Pending Tasks](#pending-tasks)
    * [Done Tasks](#done-tasks)

* In Projects
    * [CDK](cdk/README.md)
    * [Frontend](frontend/README.md)
    * [Lambda](lambda/README.md)
    * [Web API](webapi/README.md)

* In other docs
    * [Credentials & Endpoints](credentials.md)
    * [Onboarding](onboarding.md)
    * [AWS Modules](modules-aws.md)

# Daily Use

## Debug frontend 
    - `cd ~/frontend && npm run start`
    - browser on [http://localhost:4200/](http://localhost:4200/)
## Deploy frontend
    - `npm run build`
    - `cd ~/cdk && npm run build`
    - `cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Frontend`

```
    docker build . -t 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker push 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest
    docker run -p 8080:8080 085693846076.dkr.ecr.eu-west-1.amazonaws.com/estepadev/service:latest

In Browser Hit
http://Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/api/mysfits
http://192.168.99.100:8080/api/mysfits

```

### CloudFront to Hit Web App
```
aws cloudformation describe-stacks --profile samsoftware-estepa --stack-name EstepaDev-Frontend --query "Stacks[0].Outputs[?OutputKey=='CloudFrontURL'].OutputValue" --output text
http://d1u2xfsf566d4p.cloudfront.net/

```



# Pending Tasks

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

# Done Tasks
* ~~unify in one repo~~