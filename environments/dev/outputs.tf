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
