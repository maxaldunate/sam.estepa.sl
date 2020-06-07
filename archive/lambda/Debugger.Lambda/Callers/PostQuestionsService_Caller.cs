using Amazon.Lambda.APIGatewayEvents;
using Amazon.Lambda.Core;
using Moq;

namespace Debugger.Lambda.Callers
{
    public static class PostQuestionsService_Caller
    {
        public static APIGatewayProxyRequest APIGatewayProxyRequest{
        private set { } 
        get
            {
                return new APIGatewayProxyRequest();
            }
        }

        public static ILambdaContext LambdaContext{
        private set { } 
        get
            {
                return new Mock<ILambdaContext>().Object;
            }
        }

    }

}