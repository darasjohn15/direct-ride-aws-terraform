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

output "frontend_cloudfront_distribution_id" {
  description = "CloudFront distribution ID for the frontend website."
  value       = aws_cloudfront_distribution.frontend_website.id
}

output "frontend_cloudfront_distribution_arn" {
  description = "CloudFront distribution ARN for the frontend website."
  value       = aws_cloudfront_distribution.frontend_website.arn
}

output "frontend_cloudfront_domain_name" {
  description = "CloudFront domain name for the frontend website."
  value       = aws_cloudfront_distribution.frontend_website.domain_name
}

output "frontend_cloudfront_hosted_zone_id" {
  description = "CloudFront hosted zone ID for alias records."
  value       = aws_cloudfront_distribution.frontend_website.hosted_zone_id
}

output "frontend_cloudfront_url" {
  description = "HTTPS URL for the frontend website served by CloudFront."
  value       = "https://${aws_cloudfront_distribution.frontend_website.domain_name}"
}

output "frontend_waf_web_acl_arn" {
  description = "ARN of the WAF web ACL attached to the frontend CloudFront distribution."
  value       = aws_wafv2_web_acl.frontend_website.arn
}

output "frontend_waf_web_acl_id" {
  description = "ID of the WAF web ACL attached to the frontend CloudFront distribution."
  value       = aws_wafv2_web_acl.frontend_website.id
}

output "frontend_waf_web_acl_name" {
  description = "Name of the WAF web ACL attached to the frontend CloudFront distribution."
  value       = aws_wafv2_web_acl.frontend_website.name
}
