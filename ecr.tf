resource "aws_ecr_repository" "first_lambda_image_repo" {
  name = "first-lambda"
}

resource "null_resource" "first_lambda_image_source" {
  # Replace with actual Docker Hub image URI (account/image:tag)
  depends_on = [aws_ecr_repository.first_lambda_image_repo]
  
  provisioner "local-exec" {
    command = <<EOF
    docker pull jonathanpick/first-lambda:v1
    docker tag jonathanpick/first-lambda:v1 ${aws_ecr_repository.first_lambda_image_repo.repository_url}:latest
    docker push ${aws_ecr_repository.first_lambda_image_repo.repository_url}:latest
    EOF
  }
  triggers = { 
    "before" = "${aws_iam_role.lambda_role.id}"
  }

}


resource "aws_ecr_repository" "second_lambda_image_repo" {
  name = "second-lambda"
}

resource "null_resource" "second_lambda_image_source" {

  depends_on = [aws_ecr_repository.second_lambda_image_repo]

  provisioner "local-exec" {
    command = <<EOF
    docker pull jonathanpick/second-lambda:v1
    docker tag jonathanpick/second-lambda:v1 ${aws_ecr_repository.second_lambda_image_repo.repository_url}:latest
    docker push ${aws_ecr_repository.second_lambda_image_repo.repository_url}:latest
    EOF
  }
  triggers = { 
    "before" = "${aws_iam_role.lambda_role.id}"
  }
}

