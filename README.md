# SAM Estepa Serverles Project 
Max Aldunate

* Summary of Estema Serverless
* TAG {"project": "estepa-dev"} 

## Contents

* In other docs
    * [Pending Tasks](docs/tasks.md)
    * [Credentials & Endpoints](docs/credentials.md)
    * [Onboarding](docs/onboarding.md)
    * [AWS Modules](docs/aws-modern-application-workshop-dotnet-cdk-notes.md)

* In Projects

* In Archived Projects
    * [CDK](archive/cdk/README.md)
    * [Lambda](archive/lambda/README.md)
    * [Frontend](archive/frontend/README.md)
    * [Web API](archive/webapi/README.md)


# Documentation

* Deploy Frontend (On GitBash)
```bash
        cd infra
        ./deploy_frontend.sh`

            ------------- Output:
            S3_BUCKET_LOCATION eu-west-1
            View your project here: http://sam-estepa-sl-dev-frontend-085693846076.s3-website.eu-west-1.amazonaws.com
```

***********************
TASKSSSSSSSSSSSSSSSS
***********************

* Rename output.files.json
* make destroy script
* fix name on cfn to be possible to replace task.definition and other sh scripts

I'M HERE
https://github.com/aws-samples/aws-modern-application-workshop/tree/dotnet/module-2#create-a-load-balancer-listener



## OLD DOCUMENTATION
* In this doc
    * [Daily Use](#daily-use)



# Daily Use

## Debug frontend 
    - `cd ~/frontend && npm run start`
    - browser on [http://localhost:4200/](http://localhost:4200/)
## Deploy frontend
    - `npm run build`
    - `cd ~/cdk && npm run build`
    - `cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-Frontend`
## Deploy Lambdas
    - streaming_lambda `cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-KinesisFirehose`
    - PostQuestionsService `cdk deploy --profile samsoftware-estepa --require-approval never EstepaDev-XRay`
    - ProcessQuestionsStream `XRay. Same as previous lambda function`


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