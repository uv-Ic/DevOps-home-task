# AWS Lambda Deployment Guide for Interns

Welcome to your deployment task! This guide will walk you through the process of deploying AWS Lambda functions using Docker images with Terraform on LocalStack, and how to connect them to an API Gateway.

## Objective

Your mission is to:
1. Deploy a Lambda function using the `jonathanpick/first-lambda:v1` Docker image. Connect it to an API Gateway, invoke the function at its root path ("/"), **note down the hint provided in the response.**
2. Deploy a second Lambda function using the `jonathanpick/second-lambda:v1` Docker image. This time, connect it to the same API Gateway, invoke the function at its root path ("/"), and capture the secret provided in the response.

## Prerequisites

Ensure you have the following tools installed and configured:
- Docker & Docker Compose
- Terraform
- AWS CLI, configured to interact with LocalStack for local deployment

## Steps to Success

### Step 1: Setting Up LocalStack

LocalStack mimics AWS cloud services locally, allowing you to test cloud applications without incurring costs. Use Docker Compose to spin up a LocalStack instance:

**docker-compose.yml**
```yaml
version: '3.8'
services:
  localstack:
    image: localstack/localstack
    ports:
      - "4566:4566"
    environment:
      SERVICES: lambda,apigateway,iam,logs
      DEBUG: 1
    volumes:
      - "/var/run/docker.sock:/var/run/docker.sock"
```

Run docker-compose up to start LocalStack.
### Step 2: Terraform Configuration for Lambda Deployment

Create Terraform configurations to deploy your Lambda functions and set up the API Gateway. You'll need to modify the provider settings to point to LocalStack.
Deploying first-lambda with Terraform

Define your Lambda function in Terraform using the aws_lambda_function resource. Instead of specifying a ZIP file for the code, you'll use the image_uri attribute to point to the Docker image.

Example Terraform snippet:

```Terraform
resource "aws_lambda_function" "first_lambda" {
  function_name = "firstLambdaFunction"
  package_type  = "Image"
  image_uri     = "jonathanpick/first-lambda:v1"
  role          = aws_iam_role.lambda_role.arn
}
```

Repeat the process for second-lambda.
### Step 3: API Gateway Configuration

Set up an API Gateway to trigger your Lambda functions. Use Terraform to define the API Gateway and connect it to your deployed Lambda functions.

### Step 4: Invoking Your Lambda Functions

After deployment, use the AWS CLI or any HTTP client to invoke your Lambda functions through the API Gateway. The invoke URL can be obtained from the Terraform output.


### Bonus Challenge

Create a Docker Compose file to automate:

    Spinning up LocalStack.
    Running a container to deploy your Terraform configurations.
    A script to invoke your Lambda functions and display the secret.

Submission

Submit your completed project via a pull request to the designated repository, or as a ZIP file through the preferred channel.
Support

If you encounter any issues or have questions, feel free to reach out for assistance.

Good luck, and we're excited to see your solutions!
