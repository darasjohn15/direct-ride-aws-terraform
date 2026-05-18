output "ecs_cluster_id" {
  description = "ID of the ECS cluster."
  value       = aws_ecs_cluster.this.id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster."
  value       = aws_ecs_cluster.this.name
}

output "ecs_service_id" {
  description = "ID of the backend API ECS service."
  value       = aws_ecs_service.api.id
}

output "ecs_service_name" {
  description = "Name of the backend API ECS service."
  value       = aws_ecs_service.api.name
}

output "ecs_task_definition_arn" {
  description = "ARN of the backend API task definition."
  value       = aws_ecs_task_definition.api.arn
}

output "alb_arn" {
  description = "ARN of the backend API application load balancer."
  value       = aws_lb.api.arn
}

output "alb_dns_name" {
  description = "DNS name of the backend API application load balancer."
  value       = aws_lb.api.dns_name
}

output "alb_url" {
  description = "HTTP URL of the backend API application load balancer."
  value       = "http://${aws_lb.api.dns_name}"
}

output "target_group_arn" {
  description = "ARN of the backend API target group."
  value       = aws_lb_target_group.api.arn
}

output "alb_security_group_id" {
  description = "ID of the backend API ALB security group."
  value       = aws_security_group.alb.id
}

output "ecs_security_group_id" {
  description = "ID of the backend API ECS task security group."
  value       = aws_security_group.ecs_tasks.id
}

output "cloudwatch_log_group_name" {
  description = "Name of the backend API CloudWatch log group."
  value       = aws_cloudwatch_log_group.api.name
}
