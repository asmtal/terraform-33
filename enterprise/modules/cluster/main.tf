resource "aws_ecs_cluster" "main" {
  name = var.name
}

resource "aws_autoscaling_group" "autoscaling" {
  vpc_zone_identifier  = var.vpc_zone_identifier
  max_size             = var.max_size
  min_size             = 1
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.instance.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "instance" {
  image_id             = var.image_id
  instance_type        = var.instance_type
  security_groups      = [aws_security_group.instance.id]
  iam_instance_profile = aws_iam_instance_profile.instance.name
  enable_monitoring    = true

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp2"
    delete_on_termination = true
  }

  user_data = data.template_file.user_data.rendered

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "user_data" {
  template = file("${path.module}/user_data.sh")

  vars = {
    cluster_name = aws_ecs_cluster.main.name
  }
}

resource "aws_security_group" "instance" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_instance_profile" "instance" {
  role = aws_iam_role.instance.name
}

resource "aws_iam_role" "instance" {
  assume_role_policy = data.aws_iam_policy_document.instance.json
}

data "aws_iam_policy_document" "instance" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "instance_allow_calling_ecs_task_definition" {
  role       = aws_iam_role.instance.name
  policy_arn = var.allow_calling_ecs_task_definition_arn
}

resource "aws_iam_role_policy_attachment" "instance_allow_manage_catpost_s3" {
  role       = aws_iam_role.instance.name
  policy_arn = var.allow_manage_catpost_s3_arn
}

resource "aws_iam_role_policy_attachment" "instance_allow_logging" {
  role       = aws_iam_role.instance.name
  policy_arn = var.allow_logging_arn
}

resource "aws_iam_role_policy_attachment" "instance_allow_using_ssm" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "instance_allow_register_ecs" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role" "autoscaling" {
  assume_role_policy = data.aws_iam_policy_document.autoscaling.json
}

data "aws_iam_policy_document" "autoscaling" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      identifiers = ["application-autoscaling.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "autoscaling_allow_autoscaling" {
  role       = aws_iam_role.autoscaling.name
  policy_arn = var.allow_autoscaling_arn
}
