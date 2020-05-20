output "result" {
  value = random_password.main.result
}

output "name" {
  value = aws_ssm_parameter.main.name
}
