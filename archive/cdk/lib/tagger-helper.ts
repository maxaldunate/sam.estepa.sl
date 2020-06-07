import { Tag, Construct } from "@aws-cdk/core";

export const enum StackNames {
  NoStack = "NoStack",
  ApiGateway = "ApiGateway",
  Cdk = "Cdk",
  CiCd = "CiCd",
  Cognito = "Cognito",
  DevTools = "DevTools",
  DynamoDb = "DynamoDb",
  Ecr = "Ecr",
  Ecs = "Ecs",
  Network = "Network",
  WebApp = "WebApp",
  KinesisFirehose = "KinesisFirehose",
  xRay = "xRay",
}

export class Tagger  {
  public static Tag(scope: Construct,  stackName: StackNames): void {
    Tag.add(scope, 'project','estepa-dev');
    Tag.add(scope, 'stack', stackName);
  }
}
