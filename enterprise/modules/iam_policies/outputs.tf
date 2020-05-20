output "allow_logging_arn" {
  value = aws_iam_policy.allow_logging.arn
}

output "allow_calling_ecs_task_definition_arn" {
  value = aws_iam_policy.allow_calling_ecs_task_definition.arn
}

output "allow_fetching_traces_from_s3_arn" {
  value = aws_iam_policy.allow_fetching_traces_from_s3.arn
}

output "allow_uploading_traces_to_s3_arn" {
  value = aws_iam_policy.allow_uploading_traces_to_s3.arn
}

output "allow_manage_catpost_s3_arn" {
  value = aws_iam_policy.allow_manage_catpost_s3.arn
}

output "allow_put_parameter_for_runners_arn" {
  value = aws_iam_policy.allow_put_parameter_for_runners.arn
}

output "allow_get_parameter_arn" {
  value = aws_iam_policy.allow_get_parameter.arn
}

output "allow_autoscaling_arn" {
  value = aws_iam_policy.allow_autoscaling.arn
}

output "allow_get_authorization_token_arn" {
  value = aws_iam_policy.allow_get_authorization_token.arn
}
