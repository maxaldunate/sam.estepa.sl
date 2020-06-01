import cdk = require("@aws-cdk/core");
import ec2 = require("@aws-cdk/aws-ec2");
import { Tagger, StackNames }  from "./tagger-helper";

export class NetworkStack extends cdk.Stack {
  public readonly vpc: ec2.Vpc;

  constructor(scope: cdk.Construct, id: string) {
    super(scope, id);

    let stack = StackNames.Ecs;
    Tagger.Tag(this, stack);

    this.vpc = new ec2.Vpc(this, "VPC", {
      natGateways: 1,
      maxAzs: 2
    });
    Tagger.Tag(this.vpc, stack);
  }
}
