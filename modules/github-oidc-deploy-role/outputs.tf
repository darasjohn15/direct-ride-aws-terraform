output "oidc_provider_arn" {
  description = "ARN of the GitHub Actions OIDC provider used by this role."
  value       = local.oidc_provider_arn
}

output "role_arn" {
  description = "ARN of the GitHub Actions deploy role."
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "Name of the GitHub Actions deploy role."
  value       = aws_iam_role.this.name
}
