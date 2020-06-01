# Onboarding doc

### Install

* Aws CLI
```bash
cd cdk
aws ---version
    aws-cli/2.0.10 Python/3.7.5 Windows/10 botocore/2.0.0dev14
```

* NodeJs & Nmp
```bash
cd frontend
node --version
    v12.14.1
npm --version
    6.13.6
```

* Agular CLI
```bash
cd frontend
ng --version
    Your global Angular CLI version (9.1.4) is greater than your local
    version (8.0.1). The local Angular CLI version is used.
```

* Aws Amplify
```bash
cd frontend
amplify --version
    4.19.0
```

* [AWS Dotnet Amazon Lambda Tools](https://github.com/aws/aws-extensions-for-dotnet-cli)
```
cd lambda
dotnet tool install -g Amazon.Lambda.Tools
    You can invoke the tool using the following command: dotnet-lambda
    Tool 'amazon.lambda.tools' (version '4.0.0') was successfully installed.
```

* [The AWS .NET Mock Lambda Test Tool (Preview)](https://github.com/aws/aws-lambda-dotnet/tree/master/Tools/LambdaTestTool#skip-using-the-web-interface)
```
dotnet tool install -g Amazon.Lambda.TestTool-3.1
dotnet lambda-test-tool-3.1
```


* Code
Clone full 

* Code installs & build
```bash
git clone git@github.com:maxaldunate/sam.estepa.sl.git
cd sam.estepa.sl.git

cd sam.estepa.sl/cdk
npm install
npm run build

cd sam.estepa.sl/fronend
npm install
npm run build

cd sam.estepa.sl/webapi
dotnet restore
```


