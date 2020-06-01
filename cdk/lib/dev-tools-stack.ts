import cdk = require("@aws-cdk/core");
import codecommit = require("@aws-cdk/aws-codecommit");
import { Tagger, StackNames }  from "./tagger-helper";

export class DevTools extends cdk.Stack {
  public readonly apiRepository: codecommit.Repository;
  public readonly lambdaRepository: codecommit.Repository;


  constructor(scope: cdk.Construct, id: string) {
    super(scope, id);
    
    let stack = StackNames.DevTools;

    // const cdkRepository = new codecommit.Repository(this, "CDKRepository", {
    //   repositoryName: cdk.Aws.ACCOUNT_ID + "-EstepaDevService-Repository-CDK"
    // });
    // Tagger.Tag(cdkRepository, stack);

    // const webRepository = new codecommit.Repository(this, "WebRepository", {
    //   repositoryName: cdk.Aws.ACCOUNT_ID + "-EstepaDevService-Repository-Frontend"
    // });
    // Tagger.Tag(webRepository, stack);

    this.apiRepository = new codecommit.Repository(this, "APIRepository", {
      repositoryName: cdk.Aws.ACCOUNT_ID + "-EstepaDevService-Repository-Webapi"
    });
    Tagger.Tag(this.apiRepository, stack);

    this.lambdaRepository = new codecommit.Repository(this, "LambdaRepository", {
      repositoryName: cdk.Aws.ACCOUNT_ID + "-EstepaDevService-Repository-Lambda"
    });
    Tagger.Tag(this.lambdaRepository, stack);



    // new cdk.CfnOutput(this, 'CDKRepositoryCloneUrlHttp', {
    //   description: 'CDK Repository CloneUrl HTTP',
    //   value: cdkRepository.repositoryCloneUrlHttp
    // });

    // new cdk.CfnOutput(this, 'CDKRepositoryCloneUrlSsh', {
    //   description: 'CDK Repository CloneUrl SSH',
    //   value: cdkRepository.repositoryCloneUrlSsh
    // });

    // new cdk.CfnOutput(this, 'WebRepositoryCloneUrlHttp', {
    //   description: 'Web Repository CloneUrl HTTP',
    //   value: webRepository.repositoryCloneUrlHttp
    // });

    // new cdk.CfnOutput(this, 'WebRepositoryCloneUrlSsh', {
    //   description: 'Web Repository CloneUrl SSH',
    //   value: webRepository.repositoryCloneUrlSsh
    // });

    new cdk.CfnOutput(this, 'APIRepositoryCloneUrlHttp', {
      description: 'API Repository CloneUrl HTTP',
      value: this.apiRepository.repositoryCloneUrlHttp
    });

    new cdk.CfnOutput(this, 'APIRepositoryCloneUrlSsh', {
      description: 'API Repository CloneUrl SSH',
      value: this.apiRepository.repositoryCloneUrlSsh
    });

    new cdk.CfnOutput(this, "lambdaRepositoryCloneUrlHttp", {
      value: this.lambdaRepository.repositoryCloneUrlHttp,
      description: "Lambda Repository Clone Url HTTP"
    });

    new cdk.CfnOutput(this, "lambdaRepositoryCloneUrlSsh", {
      value: this.lambdaRepository.repositoryCloneUrlSsh,
      description: "Lambda Repository Clone Url SSH"
    });
  }
}