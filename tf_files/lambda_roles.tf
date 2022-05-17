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