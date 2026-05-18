output "github_actions_oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider, when enabled."
  value       = try(aws_iam_openid_connect_provider.github_actions[0].arn, null)
}

output "github_actions_deploy_role_arn" {
  description = "ARN of the GitHub Actions deploy role, when enabled."
  value       = try(aws_iam_role.github_actions_deploy[0].arn, null)
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_execution_role_name" {
  description = "Name of the ECS task execution role."
  value       = aws_iam_role.ecs_task_execution.name
}

output "ecs_task_application_role_arn" {
  description = "ARN of the ECS task application role."
  value       = aws_iam_role.ecs_task_application.arn
}

output "ecs_task_application_role_name" {
  description = "Name of the ECS task application role."
  value       = aws_iam_role.ecs_task_application.name
}

output "jwt_secret_arn" {
  description = "ARN of the JWT Secrets Manager secret."
  value       = aws_secretsmanager_secret.jwt.arn
}

output "jwt_secret_name" {
  description = "Name of the JWT Secrets Manager secret."
  value       = aws_secretsmanager_secret.jwt.name
}

output "app_config_parameter_path_prefix" {
  description = "SSM Parameter Store path prefix for backend API app config."
  value       = local.app_config_parameter_path
}

output "app_config_parameter_arns" {
  description = "ARNs of the SSM app config parameters managed by this module."
  value       = { for key, parameter in aws_ssm_parameter.app_config : key => parameter.arn }
}
