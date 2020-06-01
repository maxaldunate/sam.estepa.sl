# Sam Estepa Serverless - TASKS


# Pending Tasks

* Debug lambda on docker
* Deploy WebAPI with no unique aws-repo
* Debug & Deploy each component

* rename all mymys
* Make clicks working
* Make question's working



# Later
* Make a s3 for assets
* Migrate from Dynamo to MySql+EF Core
* Make Multitenant



* CDK improvements
	* Add Expire days to logs on cloud watchs
	* S3 file retention for artifacts, etc
	* Modify cloud watch for detailed logs
	* Put in cognito stack: Cognito Console: MysfitsUserPool/Policies/Allow users to sign themselves up


* Log&Performance serilog, elasticsearch and kibana
* Make NLB private (not internet open) 
    https://github.com/aws-samples/aws-modern-application-workshop/tree/dotnet-cdk/module-4#adding-a-new-rest-api-with-amazon-api-gateway
    "In a real-world scenario, you should create your NLB to be internal from the beginning"



* Remove every resource of a aws account (https://github.com/rebuy-de/aws-nuke)
* Add notification to EstepaDevServiceCodeBuildProject if Build failed


# Done Tasks
* ~~unify in one repo~~
* ~~Make an "on boarding" document~~
* ~~Dejar los Git repos que sean indisènsables en aws y mover el resto a github (crear para cada)~~
* ~~Renombrar Git Repos~~
* ~~Understand cdk tree dependency~~
* ~~Tagging Resources~~
* ~~Create all in a new account, previously deactivate regions~~
* ~~seed data populate-dynamodb.json~~
* ~~Everything in one git repo. Pushing each folder to deploy~~
* ~~Some Stacks are auto-run... check it, eg. Network~~
