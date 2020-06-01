# SAM Estepa Serverles Project 
Max Aldunate

* Summary of Estema Serverless
* TAG {"project": "estepa-dev"} 

## Contents

* In this doc
    * [Daily Use](#daily-use)

* In Projects
    * [CDK](cdk/README.md)
    * [Frontend](frontend/README.md)
    * [Lambda](lambda/README.md)
    * [Web API](webapi/README.md)

* In other docs
    * [Pending Tasks](docs/tasks.md)
    * [Credentials & Endpoints](docs/credentials.md)
    * [Onboarding](docs/onboarding.md)
    * [AWS Modules](docs/modules-aws.md)

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