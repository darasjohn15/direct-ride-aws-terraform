output "frontend_website_bucket_id" {
  description = "Name of the frontend website S3 bucket."
  value       = aws_s3_bucket.frontend_website.id
}

output "frontend_website_bucket_arn" {
  description = "ARN of the frontend website S3 bucket."
  value       = aws_s3_bucket.frontend_website.arn
}

output "frontend_website_bucket_regional_domain_name" {
  description = "Regional domain name of the frontend website S3 bucket."
  value       = aws_s3_bucket.frontend_website.bucket_regional_domain_name
}

output "frontend_website_endpoint" {
  description = "S3 website endpoint for the frontend website bucket."
  value       = aws_s3_bucket_website_configuration.frontend_website.website_endpoint
}

output "frontend_website_url" {
  description = "HTTP URL for the frontend website hosted by S3."
  value       = "http://${aws_s3_bucket_website_configuration.frontend_website.website_endpoint}"
}
