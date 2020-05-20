resource "aws_ecs_task_definition" "main" {
  family                = var.family
  container_definitions = var.container_definitions
  execution_role_arn    = aws_iam_role.main.arn
}

resource "aws_ecs_service" "main" {
  name                               = var.family
  task_definition                    = aws_ecs_task_definition.main.arn
  cluster                            = var.ecs_cluster_name
  deployment_maximum_percent         = 200
  deployment_minimum_healthy_percent = 75
  desired_count                      = var.desired_count

  dynamic "load_balancer" {
    // NOTE: Do not declare `load_balancer` if the container_port is 0
    for_each = var.container_port == 0 ? [] : [1]

    content {
      container_name   = var.family
      container_port   = var.container_port
      target_group_arn = var.target_group_arn
    }
  }
}

resource "aws_iam_role" "main" {
  assume_role_policy = data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ecs-tasks.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role_policy_attachment" "allow_get_parameter" {
  role       = aws_iam_role.main.name
  policy_arn = var.allow_get_parameter_arn
}

resource "aws_iam_role_policy_attachment" "allow_ecs_task_execution" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
