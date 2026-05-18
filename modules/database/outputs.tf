output "db_instance_id" {
  description = "ID of the PostgreSQL RDS instance."
  value       = aws_db_instance.postgresql.id
}

output "db_instance_arn" {
  description = "ARN of the PostgreSQL RDS instance."
  value       = aws_db_instance.postgresql.arn
}

output "db_endpoint" {
  description = "Connection endpoint for the PostgreSQL RDS instance."
  value       = aws_db_instance.postgresql.endpoint
}

output "db_address" {
  description = "Hostname of the PostgreSQL RDS instance."
  value       = aws_db_instance.postgresql.address
}

output "db_port" {
  description = "Port of the PostgreSQL RDS instance."
  value       = aws_db_instance.postgresql.port
}

output "db_name" {
  description = "Initial PostgreSQL database name."
  value       = aws_db_instance.postgresql.db_name
}

output "db_username" {
  description = "PostgreSQL master username."
  value       = aws_db_instance.postgresql.username
}

output "db_master_user_secret_arn" {
  description = "ARN of the Secrets Manager secret for the generated master user password."
  value       = aws_db_instance.postgresql.master_user_secret[0].secret_arn
}

output "db_security_group_id" {
  description = "ID of the PostgreSQL security group."
  value       = aws_security_group.postgresql.id
}
