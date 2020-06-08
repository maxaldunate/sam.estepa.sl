# Onboarding - Install required tools

## Minimal tooling

* [Visual Studio Code](https://code.visualstudio.com/)
* [git](https://git-scm.com/downloads)
* [AWS CLI](https://aws.amazon.com/cli/) or [AWS Tools for PowerShell](https://aws.amazon.com/powershell/)
    * Pick a tool based on the environment you're more comfortable with:
        * Bash -- AWS CLI
        * PowerShell -- AWS Tools for PowerShell
* [Node.js and NPM](https://nodejs.org/en/) - v12 or greater
```bash
        node --version
            v12.14.1
        npm --version
            6.13.6
```
* [.NET Core 2.1](https://www.microsoft.com/net/download)
* [Angular CLI](https://cli.angular.io/)
    * npm install -g @angular/cli
```bash
        ng --version
            Your global Angular CLI version (9.1.4) is greater than your local
            version (8.0.1). The local Angular CLI version is used.
```    
* [AWS Amplify](https://aws-amplify.github.io/)
    * npm install -g @aws-amplify/cli
```bash
        amplify --version
            4.19.0
```
    
## Other Tools
* Aws CLI
```bash
aws ---version
    aws-cli/2.0.10 Python/3.7.5 Windows/10 botocore/2.0.0dev14
```
* [AWS Dotnet Amazon Lambda Tools](https://github.com/aws/aws-extensions-for-dotnet-cli)
```
dotnet tool install -g Amazon.Lambda.Tools
    You can invoke the tool using the following command: dotnet-lambda
    Tool 'amazon.lambda.tools' (version '4.0.0') was successfully installed.
```

* [The AWS .NET Mock Lambda Test Tool (Preview)](https://github.com/aws/aws-lambda-dotnet/tree/master/Tools/LambdaTestTool#skip-using-the-web-interface)
```
dotnet tool install -g Amazon.Lambda.TestTool-3.1
dotnet lambda-test-tool-3.1
```

* [Docker](https://docs.docker.com/get-docker/)


