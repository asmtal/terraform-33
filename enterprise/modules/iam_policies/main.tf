locals {
  parameter_store_name_prefix = replace(var.parameter_store_name_prefix, "/\\/$/", "")
}

resource "aws_iam_policy" "allow_logging" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_logging.json
}

data "aws_iam_policy_document" "allow_logging" {
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "allow_calling_ecs_task_definition" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_calling_ecs_task_definition.json
}

data "aws_iam_policy_document" "allow_calling_ecs_task_definition" {
  statement {
    actions = [
      "iam:PassRole",
      "ecs:DescribeTasks",
      "ecs:RunTask",
      "ecs:RegisterTaskDefinition"
    ]

    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "allow_fetching_traces_from_s3" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_fetching_traces_from_s3.json
}

data "aws_iam_policy_document" "allow_fetching_traces_from_s3" {
  statement {
    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${var.traces_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "allow_uploading_traces_to_s3" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_uploading_traces_to_s3.json
}

data "aws_iam_policy_document" "allow_uploading_traces_to_s3" {
  statement {
    actions = [
      "s3:PutObject"
    ]

    resources = [
      "${var.traces_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "allow_manage_catpost_s3" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_manage_catpost_s3.json
}

data "aws_iam_policy_document" "allow_manage_catpost_s3" {
  statement {
    actions = [
      "s3:*"
    ]

    resources = [
      "${var.catpost_bucket_arn}/*"
    ]
  }
}

resource "aws_iam_policy" "allow_put_parameter_for_runners" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_put_parameter_for_runners.json
}

data "aws_iam_policy_document" "allow_put_parameter_for_runners" {
  statement {
    actions = [
      "ssm:PutParameter"
    ]

    resources = [
      "arn:aws:ssm:*:*:parameter/${local.parameter_store_name_prefix}/*"
    ]
  }
}

resource "aws_iam_policy" "allow_get_parameter" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_get_parameter.json
}

data "aws_iam_policy_document" "allow_get_parameter" {
  statement {
    actions = [
      "ssm:GetParameters",
      "kms:Decrypt"
    ]

    resources = [
      "arn:aws:ssm:${var.aws_region}:${var.account_id}:parameter/${local.parameter_store_name_prefix}/*",
      "arn:aws:kms:${var.aws_region}:${var.account_id}:key/*"
    ]
  }
}

resource "aws_iam_policy" "allow_autoscaling" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_autoscaling.json
}

data "aws_iam_policy_document" "allow_autoscaling" {
  statement {
    actions = [
      "application-autoscaling:*",
      "cloudwatch:DescribeAlarms",
      "cloudwatch:PutMetricAlarm",
      "ecs:DescribeServices",
      "ecs:UpdateService"
    ]

    resources = [
      "*"
    ]
  }
}

// TODO: Consider the following IAM policies should be created or not
resource "aws_iam_policy" "allow_get_authorization_token" {
  name_prefix = var.iam_policy_name_prefix
  policy      = data.aws_iam_policy_document.allow_get_authorization_token.json
}

data "aws_iam_policy_document" "allow_get_authorization_token" {
  statement {
    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = [
      "*"
    ]
  }
}
