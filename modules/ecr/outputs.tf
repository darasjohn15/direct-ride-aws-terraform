output "repository_name" {
  description = "Name of the backend API ECR repository."
  value       = aws_ecr_repository.api.name
}

output "repository_arn" {
  description = "ARN of the backend API ECR repository."
  value       = aws_ecr_repository.api.arn
}

output "repository_url" {
  description = "URL of the backend API ECR repository."
  value       = aws_ecr_repository.api.repository_url
}

output "registry_id" {
  description = "Registry ID that owns the backend API ECR repository."
  value       = aws_ecr_repository.api.registry_id
}
