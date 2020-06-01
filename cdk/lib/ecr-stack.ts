import cdk = require("@aws-cdk/core");
import ecr = require("@aws-cdk/aws-ecr");
import { Tagger, StackNames }  from "./tagger-helper";

export class EcrStack extends cdk.Stack {
  public readonly ecrRepository: ecr.Repository;

  constructor(scope: cdk.Construct, id: string) {
    super(scope, id);
    let stack = StackNames.Ecr;
    Tagger.Tag(this, stack);

    this.ecrRepository = new ecr.Repository(this, "Repository", {
      repositoryName: "estepadev/service"
    });
    Tagger.Tag(this.ecrRepository, stack);
  }
}
