output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "instance_security_group_id" {
  value = aws_security_group.instance.id
}

output "autoscaling_role_arn" {
  value = aws_iam_role.autoscaling.arn
}
