using System;
using System.IO;
using System.Threading.Tasks;
using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.KinesisFirehoseEvents;
using Debugger.Lambda.Callers;

namespace Debugger.Lambda
{
    /*
        Getting started with writing and debugging AWS Lambda Function with Visual Studio Code
        https://cloudncode.blog/2017/01/24/getting-started-with-writing-and-debugging-aws-lambda-function-with-visual-studio-code/
    */

    class Program
    {
        static void Main(string[] args)
        {
            Task.Run(async () =>
            {
                try
                {
                    switch (args[0])
                    {
                        case "PostQuestionsService":
                            await CallPostQuestionsService();
                            break;
                        case "ProcessQuestionsStream":
                            await CallProcessQuestionsStream();
                            break;
                        case "stream":
                            await Callstream();
                            break;
                        default:
                            throw new Exception("Must have one argument with lambda name to debugg");
                    }
                }
                catch (System.Exception ex)
                {
                    System.Console.WriteLine(ex.Message);
                    throw;
                }
                

            }).GetAwaiter().GetResult();

        }

        private async static Task<APIGatewayProxyResponse> CallPostQuestionsService()
        {
            var p1 = PostQuestionsService_Caller.APIGatewayProxyRequest;
            var p2 = PostQuestionsService_Caller.LambdaContext;
            return await new PostQuestionsService.Function().FunctionHandlerAsync(p1, p2);
        }

        private async static Task CallProcessQuestionsStream()
        {
            await new ProcessQuestionsStream.Function().FunctionHandlerAsync(null, null);
        }

        private async static Task<KinesisFirehoseResponse> Callstream()
        {
            return await new streaming_lambda.Function().FunctionHandlerAsync(null, null);
        }

    }
}


//"program": "${workspaceFolder}/lambda/PostQuestionsService/bin/Debug/netcoreapp2.1/PostQuestionsService.dll",