import * as cdk from '@aws-cdk/core';
import { Tagger, StackNames }  from "./tagger-helper";

export class CdkStack extends cdk.Stack {
  constructor(scope: cdk.Construct, id: string, props?: cdk.StackProps) {
    super(scope, id, props);
    
    Tagger.Tag(this, StackNames.Cdk);

    // The code that defines your stack goes here
  }
}
