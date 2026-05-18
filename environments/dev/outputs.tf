output "vpc_id" {
  description = "ID of the dev VPC."
  value       = module.networking.vpc_id
}

output "public_subnet_ids" {
  description = "IDs of the dev public subnets."
  value       = module.networking.public_subnet_ids
}

output "private_app_subnet_ids" {
  description = "IDs of the dev private application subnets."
  value       = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  description = "IDs of the dev private database subnets."
  value       = module.networking.private_db_subnet_ids
}

output "db_subnet_group_name" {
  description = "Name of the dev database subnet group."
  value       = module.networking.db_subnet_group_name
}

output "frontend_website_bucket_id" {
  description = "Name of the dev frontend website S3 bucket."
  value       = module.storage.frontend_website_bucket_id
}

output "frontend_website_bucket_arn" {
  description = "ARN of the dev frontend website S3 bucket."
  value       = module.storage.frontend_website_bucket_arn
}

output "frontend_website_bucket_regional_domain_name" {
  description = "Regional domain name of the dev frontend website S3 bucket."
  value       = module.storage.frontend_website_bucket_regional_domain_name
}

output "frontend_website_endpoint" {
  description = "S3 website endpoint for the dev frontend website bucket."
  value       = module.storage.frontend_website_endpoint
}

output "frontend_website_url" {
  description = "HTTP URL for the dev frontend website hosted by S3."
  value       = module.storage.frontend_website_url
}

output "db_instance_id" {
  description = "ID of the dev PostgreSQL RDS instance."
  value       = module.database.db_instance_id
}

output "db_endpoint" {
  description = "Connection endpoint for the dev PostgreSQL RDS instance."
  value       = module.database.db_endpoint
}

output "db_address" {
  description = "Hostname of the dev PostgreSQL RDS instance."
  value       = module.database.db_address
}

output "db_port" {
  description = "Port of the dev PostgreSQL RDS instance."
  value       = module.database.db_port
}

output "db_name" {
  description = "Initial dev PostgreSQL database name."
  value       = module.database.db_name
}

output "db_username" {
  description = "Dev PostgreSQL master username."
  value       = module.database.db_username
}

output "db_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret for the generated dev database master password."
  value       = module.database.db_master_user_secret_arn
}

output "db_security_group_id" {
  description = "ID of the dev PostgreSQL security group."
  value       = module.database.db_security_group_id
}

output "backend_api_ecr_repository_name" {
  description = "Name of the dev backend API ECR repository."
  value       = module.ecr.repository_name
}

output "backend_api_ecr_repository_arn" {
  description = "ARN of the dev backend API ECR repository."
  value       = module.ecr.repository_arn
}

output "backend_api_ecr_repository_url" {
  description = "URL of the dev backend API ECR repository."
  value       = module.ecr.repository_url
}

output "backend_api_container_image" {
  description = "Container image URI used by the dev backend API ECS task."
  value       = "${module.ecr.repository_url}:${var.backend_api_image_tag}"
}

output "backend_api_ecs_cluster_name" {
  description = "Name of the dev backend API ECS cluster."
  value       = module.compute.ecs_cluster_name
}

output "backend_api_ecs_service_name" {
  description = "Name of the dev backend API ECS service."
  value       = module.compute.ecs_service_name
}

output "backend_api_task_definition_arn" {
  description = "ARN of the dev backend API task definition."
  value       = module.compute.ecs_task_definition_arn
}

output "backend_api_alb_dns_name" {
  description = "DNS name of the dev backend API application load balancer."
  value       = module.compute.alb_dns_name
}

output "backend_api_alb_url" {
  description = "HTTP URL for the dev backend API application load balancer."
  value       = module.compute.alb_url
}

output "backend_api_target_group_arn" {
  description = "ARN of the dev backend API target group."
  value       = module.compute.target_group_arn
}

output "backend_api_alb_security_group_id" {
  description = "ID of the dev backend API ALB security group."
  value       = module.compute.alb_security_group_id
}

output "backend_api_ecs_security_group_id" {
  description = "ID of the dev backend API ECS task security group."
  value       = module.compute.ecs_security_group_id
}

output "github_actions_oidc_provider_arn" {
  description = "ARN of the dev GitHub Actions OIDC provider, when enabled."
  value       = module.security.github_actions_oidc_provider_arn
}

output "github_actions_deploy_role_arn" {
  description = "ARN of the dev GitHub Actions deploy role, when enabled."
  value       = module.security.github_actions_deploy_role_arn
}

output "backend_api_task_execution_role_arn" {
  description = "ARN of the dev backend API ECS task execution role."
  value       = module.security.ecs_task_execution_role_arn
}

output "backend_api_task_application_role_arn" {
  description = "ARN of the dev backend API ECS task application role."
  value       = module.security.ecs_task_application_role_arn
}

output "jwt_secret_arn" {
  description = "ARN of the dev JWT Secrets Manager secret."
  value       = module.security.jwt_secret_arn
}

output "jwt_secret_name" {
  description = "Name of the dev JWT Secrets Manager secret."
  value       = module.security.jwt_secret_name
}

output "app_config_parameter_path_prefix" {
  description = "SSM Parameter Store path prefix for dev backend API app config."
  value       = module.security.app_config_parameter_path_prefix
}

output "app_config_parameter_arns" {
  description = "ARNs of the dev SSM app config parameters managed by Terraform."
  value       = module.security.app_config_parameter_arns
}
