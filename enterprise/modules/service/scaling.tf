resource "aws_appautoscaling_target" "main" {
  service_namespace  = "ecs"
  scalable_dimension = "ecs:service:DesiredCount"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.main.name}"
  max_capacity       = 10
  min_capacity       = 2
  role_arn           = var.autoscaling_role_arn
}

resource "aws_appautoscaling_policy" "main_down" {
  name               = "scale/sider_enterprise/${var.family}/down"
  resource_id        = aws_appautoscaling_target.main.id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"
    cooldown                = 60

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

resource "aws_appautoscaling_policy" "main_up" {
  name               = "scale/sider_enterprise/${var.family}/up"
  resource_id        = aws_appautoscaling_target.main.id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    metric_aggregation_type = "Average"
    cooldown                = 60

    step_adjustment {
      metric_interval_lower_bound = 0
      metric_interval_upper_bound = 15
      scaling_adjustment          = 1
    }

    step_adjustment {
      metric_interval_lower_bound = 15
      metric_interval_upper_bound = 25
      scaling_adjustment          = 2
    }

    step_adjustment {
      metric_interval_lower_bound = 25
      scaling_adjustment          = 3
    }
  }
}
