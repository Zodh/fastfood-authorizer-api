locals {
  postgres_user     = base64decode(data.kubernetes_secret.fastfood_secret.data["POSTGRES_USER"])
  postgres_password = base64decode(data.kubernetes_secret.fastfood_secret.data["POSTGRES_PASSWORD"])
}

# Cria recurso lambda
resource "aws_lambda_function" "eks_invoker" {
  function_name = "eks-invoker"
  runtime       = "nodejs20.x"  # Atualizado para Node.js 20
  handler       = "index.lambdaHandler"  # Handler no código Node.js (ajustado para Node.js)
  role          = data.aws_iam_role.example.arn
  filename      = "lambda_function.zip"  # Caminho para o arquivo zip do código Lambda

  environment {
    variables = {
      EXTERNAL_IP_API  = "http://${data.kubernetes_service.fastfood_service.status[0].load_balancer[0].ingress[0].hostname}:80"
      EXTERNAL_IP_PAYMENT  = "http://${data.kubernetes_service.payment_service.status[0].load_balancer[0].ingress[0].hostname}:80"
      DB_NAME      = "postgres"
      DB_HOST      = split(":", data.aws_db_instance.rds.endpoint)[0]
      DB_USER      = local.postgres_user
      DB_PASSWORD  = local.postgres_password
    }
  }
}

# Recurso dinâmico base "/{proxy+}"
resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = data.aws_api_gateway_rest_api.eks_api.id
  parent_id   = data.aws_api_gateway_rest_api.eks_api.root_resource_id
  path_part   = "{proxy+}"
}

# Método para todas as requisições
resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = data.aws_api_gateway_rest_api.eks_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# Integração com o Lambda
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = data.aws_api_gateway_rest_api.eks_api.id
  resource_id = aws_api_gateway_resource.proxy.id
  http_method = aws_api_gateway_method.proxy_method.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.eks_invoker.invoke_arn
}

# Permissão para o Lambda ser invocado pelo API Gateway
resource "aws_lambda_permission" "api_gateway_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.eks_invoker.arn
  principal     = "apigateway.amazonaws.com"
}

resource "aws_api_gateway_deployment" "eks_api_deployment" {
  rest_api_id = data.aws_api_gateway_rest_api.eks_api.id
  stage_name  = "prod"

  depends_on = [
    aws_api_gateway_method.proxy_method, aws_api_gateway_integration.lambda_integration
  ]
}