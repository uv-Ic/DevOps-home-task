resource "aws_api_gateway_rest_api" "MyDemoAPI" {
  depends_on = [ aws_lambda_function.second_lambda,
                 aws_lambda_function.first_lambda ]
  name        = "My Demo API"
  description = "My Demo API"

}


output "root_resource_id" {
  value = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
}

resource "aws_api_gateway_resource" "MyDemoResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "first"
}

resource "aws_api_gateway_method" "MyDemoMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.MyDemoResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_resource" "SecondResource" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  parent_id   = aws_api_gateway_rest_api.MyDemoAPI.root_resource_id
  path_part   = "second"
}

resource "aws_api_gateway_method" "SecondMethod" {
  rest_api_id   = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id   = aws_api_gateway_resource.SecondResource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "MyDemoIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.MyDemoResource.id
  http_method = aws_api_gateway_method.MyDemoMethod.http_method

  integration_http_method = "POST" # Lambda functions are invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.first_lambda.invoke_arn
}

resource "aws_api_gateway_integration" "SecondIntegration" {
  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  resource_id = aws_api_gateway_resource.SecondResource.id
  http_method = aws_api_gateway_method.SecondMethod.http_method

  integration_http_method = "POST" # Lambda functions are invoked with POST
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.second_lambda.invoke_arn

  request_parameters = {
    "integration.request.header.Authorization" = "method.request.header.Authorization"
  }
}

resource "aws_lambda_permission" "MyDemoLambdaPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.first_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN specifies that only the specified API Gateway can invoke the function
  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/*/*"
}


resource "aws_lambda_permission" "SecondLambdaPermission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.second_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN specifies that only the specified API Gateway can invoke the function
  source_arn = "${aws_api_gateway_rest_api.MyDemoAPI.execution_arn}/*/*/*"
}

resource "aws_api_gateway_deployment" "MyDemoDeployment" {
  depends_on = [
    aws_api_gateway_integration.MyDemoIntegration,
    aws_api_gateway_integration.SecondIntegration
  ]

  rest_api_id = aws_api_gateway_rest_api.MyDemoAPI.id
  stage_name  = "test"
}



output "rest_api_id" {
  value = aws_api_gateway_rest_api.MyDemoAPI.id
}

