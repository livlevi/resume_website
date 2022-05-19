#Lambda role to allow function access to DynamoDB

resource "aws_iam_role" "siteVisitLambdaRole" {
  name = "siteVisitLambdaRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
  tags = {
    Description = "Role to give Lambda permissions to access DynamoDB"
  }
}

# Attaching managed policies to IAM role.

resource "aws_iam_role_policy_attachment" "siteVisitLambdaRole" {
  role       = aws_iam_role.siteVisitLambdaRole.name
  count      = "${length(var.siteVisit_policy_arn)}"
  policy_arn = "${var.siteVisit_policy_arn[count.index]}"
}

# Allowing TF to zip the files, it appears that TF doesn't recognize zipped files created by 7zip.

data "archive_file" "zippedLambdaPutFunction" {
  type = "zip"
  source_file = "lambda_function/lambda_put_function.py"
  output_path = "lambda_put_function.zip"
}

# Creating Lambda roles 

resource "aws_lambda_function" "leviSitePutFunction" {
  filename      = "lambda_put_function.zip"
  function_name = "leviSitePutFunction"
  role          = aws_iam_role.siteVisitLambdaRole.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${data.archive_file.zippedLambdaPutFunction.output_base64sha256}"

}

data "archive_file" "zippedLambdaGetFunction" {
  type = "zip"
  source_file = "lambda_function/lambda_get_function.py"
  output_path = "lambda_get_function.zip"
}

resource "aws_lambda_function" "leviSiteGetFunction" {
  filename      = "lambda_get_function.zip"
  function_name = "leviSiteGetFunction"
  role          = aws_iam_role.siteVisitLambdaRole.arn
  handler       = "main.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${data.archive_file.zippedLambdaGetFunction.output_base64sha256}"
}

# Attaching managed policies to Lambda role

resource "aws_iam_role" "cifLambdaSendingRole" {
  name = "cifLambdaSendingRole"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})
  tags = {
    Description = "Role to give Lambda permissions use SES and SNS and Step Functions"
  }
}

resource "aws_iam_role_policy_attachment" "cifLambdaSendingRole" {
  role       = aws_iam_role.cifLambdaSendingRole.name
  count      = "${length(var.cifSending_policy_arn)}"
  policy_arn = "${var.cifSending_policy_arn[count.index]}"
}


data "archive_file" "zippedRESTAPIHandler" {
  type = "zip"
  source_file = "lambda_function/cifRESTAPIHandler.py"
  output_path = "cifRESTAPIHandler.zip"
}

resource "aws_lambda_function" "cifRESTAPIHandler" {
  filename      = "cifRESTAPIHandler.zip"
  function_name = "cifRESTAPIHandler"
  role          = aws_iam_role.cifLambdaSendingRole.arn
  handler       = "cifRESTAPIHandler.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${data.archive_file.zippedRESTAPIHandler.output_base64sha256}"
}

data "archive_file" "zippedSMSLambda" {
  type = "zip"
  source_file = "lambda_function/cifSMSLambda.py"
  output_path = "cifSMSLambda.zip"
}

resource "aws_lambda_function" "cifSMSLambda" {
  filename      = "cifSMSLambda.zip"
  function_name = "cifSMSLambda"
  role          = aws_iam_role.cifLambdaSendingRole.arn
  handler       = "cifSMSLambda.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${data.archive_file.zippedSMSLambda.output_base64sha256}"
}

data "archive_file" "zippedEmailLambda" {
  type = "zip"
  source_file = "lambda_function/cifEmailLambda.py"
  output_path = "cifEmailLambda.zip"
}

resource "aws_lambda_function" "cifEmailLambda" {
  filename      = "cifEmailLambda.zip"
  function_name = "cifEmailLambda"
  role          = aws_iam_role.cifLambdaSendingRole.arn
  handler       = "cifEmailLambda.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = "${data.archive_file.zippedEmailLambda.output_base64sha256}"
}

