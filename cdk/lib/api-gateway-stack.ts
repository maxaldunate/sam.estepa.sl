import apigateway = require('@aws-cdk/aws-apigateway');
import cdk = require('@aws-cdk/core');
import elbv2 = require('@aws-cdk/aws-elasticloadbalancingv2');
import fs = require('fs');
import path = require('path');
import { Tagger, StackNames }  from "./tagger-helper";

interface APIGatewayStackProps extends cdk.StackProps {
  loadBalancerDnsName: string;
  loadBalancerArn: string;
  userPoolId: string;
}
export class APIGatewayStack extends cdk.Stack {
  public readonly apiId: string;

  constructor(scope: cdk.App, id: string, props: APIGatewayStackProps) {
    super(scope, id);
    let stack = StackNames.ApiGateway;

    const nlb = elbv2.NetworkLoadBalancer.fromNetworkLoadBalancerAttributes(this, 'NLB', {
      loadBalancerArn: props.loadBalancerArn
    });
    Tagger.Tag(this, stack);

    const vpcLink = new apigateway.VpcLink(this, 'VPCLink', {
      description: 'VPC Link for our  REST API',
      vpcLinkName: 'MysfitsApiVpcLink',
      targets: [
        nlb
      ]
    });
    Tagger.Tag(vpcLink, stack);

    const schema = this.generateSwaggerSpec(props.loadBalancerDnsName, props.userPoolId, vpcLink);
    const jsonSchema = JSON.parse(schema);
    const api = new apigateway.CfnRestApi(this, 'Schema', {
      name: 'MysfitsApi',
      body: jsonSchema,
      endpointConfiguration: {
        types: [
          apigateway.EndpointType.REGIONAL
        ]
      },
      failOnWarnings: true
    });
    Tagger.Tag(api, stack);

    new apigateway.CfnDeployment(this, 'Prod', {
      restApiId: api.ref,
      stageName: 'prod'
    });
    new cdk.CfnOutput(this, 'APIID', {
      value: api.ref,
      description: 'API Gateway ID'
    })
    this.apiId = api.ref;
  }

  // private generateSwaggerSpec(dnsName: string, userPoolId: string, vpcLink: apigateway.VpcLink): string {
  //   const schemaFilePath = path.resolve(__dirname + '/../api-swagger.json');
  //   const apiSchema = fs.readFileSync(schemaFilePath);
  //   let schema: string = apiSchema.toString().replace(/eu-west-1/gi, cdk.Aws.REGION);
  //   schema = schema.toString().replace(/085693846076/gi, cdk.Aws.ACCOUNT_ID);
  //   schema = schema.toString().replace(/eu-west-1_d7fdSAgua/gi, userPoolId);
  //   schema = schema.toString().replace(/yns36h/gi, vpcLink.vpcLinkId);
  //   schema = schema.toString().replace(/Estep-Servi-195O26F1ZHFC1-cb324d4be6285e6d.elb.eu-west-1.amazonaws.com/gi, dnsName);
  //   return schema;
  // }

  private generateSwaggerSpec(dnsName: string, userPoolId: string, vpcLink: apigateway.VpcLink): string {
    //const schemaFilePath = path.resolve(__dirname + '/../../api/api-swagger.json');
    const schemaFilePath = path.resolve(__dirname + '/../api-swagger.json');
    const apiSchema = fs.readFileSync(schemaFilePath);
    let schema: string = apiSchema.toString().replace(/REPLACE_ME_REGION/gi, cdk.Aws.REGION);
    schema = schema.toString().replace(/REPLACE_ME_ACCOUNT_ID/gi, cdk.Aws.ACCOUNT_ID);
    schema = schema.toString().replace(/REPLACE_ME_COGNITO_USER_POOL_ID/gi, userPoolId);
    schema = schema.toString().replace(/REPLACE_ME_VPC_LINK_ID/gi, vpcLink.vpcLinkId);
    schema = schema.toString().replace(/REPLACE_ME_NLB_DNS/gi, dnsName);
    return schema;
  }
}

// BRowse
// https://REPLACE_ME_WITH_API_ID.execute-api.REPLACE_ME_WITH_REGION.amazonaws.com/prod/api/mysfits
// https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api/mysfits
// https://fma29g1jh9.execute-api.eu-west-1.amazonaws.com/prod/api/mysfits/2b473002-36f8-4b87-954e-9a377e0ccbec