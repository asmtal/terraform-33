resource "aws_ssm_parameter" "main" {
  name  = var.name
  type  = "SecureString"
  value = random_password.main.result
}

resource "random_password" "main" {
  length  = var.length
  special = var.special
}
