resource "aws_cloudwatch_metric_alarm" "main" {
  for_each = {
    low_cpu = {
      alarm_name          = "low-cpu-sider-enterprise-${var.family}"
      alarm_description   = "Low CPU utilization for service ${var.family} of Sider Enterprise"
      threshold           = 3
      comparison_operator = "LessThanOrEqualToThreshold"
      alarm_action        = aws_appautoscaling_policy.main_down.arn
    }
    high_cpu = {
      alarm_name          = "high-cpu-sider-enterprise-${var.family}"
      alarm_description   = "High CPU utilization for service ${var.family} of Sider Enterprise"
      threshold           = 3
      comparison_operator = "GreaterThanOrEqualToThreshold"
      alarm_action        = aws_appautoscaling_policy.main_up.arn
    }
  }

  alarm_name        = each.value["alarm_name"]
  alarm_description = each.value["alarm_name"]
  metric_name       = "CPUUtilization"
  namespace         = "AWS/ECS"

  dimensions = {
    ServiceName = var.family
    ClusterName = var.ecs_cluster_name
  }

  statistic           = "Average"
  period              = 60
  evaluation_periods  = 1
  threshold           = each.value["threshold"]
  comparison_operator = each.value["comparison_operator"]
  alarm_actions       = [each.value["alarm_action"]]
}
