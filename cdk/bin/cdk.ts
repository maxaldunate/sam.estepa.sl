#!/usr/bin/env node

import cdk = require('@aws-cdk/core');
import 'source-map-support/register';
import { DynamoDbStack } from '../lib/dynamodb-stack';
import { NetworkStack } from '../lib/network-stack';
import { FrontendStack } from '../lib/Frontend-stack';
import { DevTools } from "../lib/dev-tools-stack";
import { APIGatewayStack } from "../lib/api-gateway-stack";
import { EcrStack } from "../lib/ecr-stack";
import { EcsStack } from "../lib/ecs-stack";
import { KinesisFirehoseStack } from "../lib/kinesis-firehose-stack";
import { CiCdStack } from "../lib/cicd-stack";
import { CognitoStack } from '../lib/cognito-stack';
import { XRayStack } from '../lib/xray-stack';

const app = new cdk.App();
const devToolsStack = new DevTools(app, 'EstepaDev-DevTools');
new FrontendStack(app, "EstepaDev-Frontend");
const networkStack = new NetworkStack(app, "EstepaDev-Network");
const ecrStack = new EcrStack(app, "EstepaDev-ECR");
const ecsStack = new EcsStack(app, "EstepaDev-ECS", {
    vpc: networkStack.vpc,
    ecrRepository: ecrStack.ecrRepository
});
new CiCdStack(app, "EstepaDev-CICD", {
    ecrRepository: ecrStack.ecrRepository,
    ecsService: ecsStack.ecsService.service,
    apiRepositoryArn: devToolsStack.apiRepository.repositoryArn
});
const dynamoDBStack = new DynamoDbStack(app, "EstepaDev-DynamoDB", {
    vpc: networkStack.vpc,
    fargateService: ecsStack.ecsService.service
});
const cognito = new CognitoStack(app, "EstepaDev-Cognito");
const apiGateway = new APIGatewayStack(app, "EstepaDev-APIGateway", {
    userPoolId: cognito.userPool.userPoolId,
    loadBalancerArn: ecsStack.ecsService.loadBalancer.loadBalancerArn,
    loadBalancerDnsName: ecsStack.ecsService.loadBalancer.loadBalancerDnsName
});
new KinesisFirehoseStack(app, "EstepaDev-KinesisFirehose", {
    table: dynamoDBStack.table,
    apiId: apiGateway.apiId
});
new XRayStack(app, "EstepaDev-XRay");
app.synth();