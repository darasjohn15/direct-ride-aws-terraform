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
