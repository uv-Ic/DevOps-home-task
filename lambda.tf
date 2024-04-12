
resource "aws_lambda_function" "first_lambda" {
#   depends_on    = [null_resource.first_lambda_image_source]
  depends_on = [ null_resource.first_lambda_image_source ]
  function_name = "firstLambdaFunction"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.first_lambda_image_repo.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  vpc_config {
    security_group_ids = [aws_security_group.allow_web.arn]
    subnet_ids         = [aws_subnet.my_subnet_private.id]
  }

}

resource "aws_lambda_function" "second_lambda" {
  depends_on = [null_resource.second_lambda_image_source]
  function_name = "secondLambdaFunction"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.second_lambda_image_repo.repository_url}:latest"
  role          = aws_iam_role.lambda_role.arn
  vpc_config {
    security_group_ids = [aws_security_group.allow_web.arn]
    subnet_ids         = [aws_subnet.my_subnet_private.id]
  }


}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"

  assume_role_policy = jsonencode({
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
